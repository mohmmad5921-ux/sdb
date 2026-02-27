<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Card;
use Illuminate\Http\Request;

class AppleWalletController extends Controller
{
    /**
     * Generate a .pkpass file for a card
     */
    public function generatePass(Request $request, Card $card)
    {
        // Ensure user owns this card
        if ($card->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $certPath = config('services.apple_wallet.certificate');
        $certPassword = config('services.apple_wallet.password');
        $wwdrPath = config('services.apple_wallet.wwdr');
        $passTypeId = config('services.apple_wallet.pass_type_id');
        $teamId = config('services.apple_wallet.team_id');

        if (!$certPath || !file_exists($certPath)) {
            // Fallback: generate unsigned pass bundle (for demo)
            return $this->generateDemoPass($card);
        }

        return $this->generateSignedPass($card, $certPath, $certPassword, $wwdrPath, $passTypeId, $teamId);
    }

    /**
     * Generate a signed PKPass (production)
     */
    private function generateSignedPass(Card $card, $certPath, $certPassword, $wwdrPath, $passTypeId, $teamId)
    {
        $tempDir = sys_get_temp_dir() . '/pkpass_' . uniqid();
        mkdir($tempDir, 0755, true);

        // 1. Create pass.json
        $passJson = $this->buildPassJson($card, $passTypeId, $teamId);
        file_put_contents("$tempDir/pass.json", json_encode($passJson, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

        // 2. Copy icon/logo assets
        $this->copyAssets($tempDir);

        // 3. Create manifest.json (SHA1 hash of every file)
        $manifest = [];
        foreach (glob("$tempDir/*") as $file) {
            if (is_file($file)) {
                $manifest[basename($file)] = sha1(file_get_contents($file));
            }
        }
        file_put_contents("$tempDir/manifest.json", json_encode($manifest));

        // 4. Sign manifest with certificate
        $signedPath = "$tempDir/signature";
        openssl_pkcs7_sign(
            "$tempDir/manifest.json",
            $signedPath,
            "file://$certPath",
        ["file://$certPath", $certPassword],
        [],
            PKCS7_BINARY | PKCS7_DETACHED,
            $wwdrPath
        );

        // Extract DER signature from the PEM output
        $signature = file_get_contents($signedPath);
        $derStart = strpos($signature, "\n\n") + 2;
        $signature = base64_decode(str_replace(["\n", "\r"], '', substr($signature, $derStart, strrpos($signature, "\n-----") - $derStart)));
        file_put_contents($signedPath, $signature);

        // 5. Create .pkpass ZIP
        $pkpassPath = "$tempDir/card.pkpass";
        $zip = new \ZipArchive();
        $zip->open($pkpassPath, \ZipArchive::CREATE);
        foreach (glob("$tempDir/*") as $file) {
            if (is_file($file) && basename($file) !== 'card.pkpass') {
                $zip->addFile($file, basename($file));
            }
        }
        $zip->close();

        // Return the .pkpass file
        $content = file_get_contents($pkpassPath);

        // Cleanup
        array_map('unlink', glob("$tempDir/*"));
        rmdir($tempDir);

        return response($content, 200)
            ->header('Content-Type', 'application/vnd.apple.pkpass')
            ->header('Content-Disposition', 'attachment; filename="sdb_card.pkpass"');
    }

    /**
     * Generate demo pass (unsigned — for testing)
     */
    private function generateDemoPass(Card $card)
    {
        $tempDir = sys_get_temp_dir() . '/pkpass_' . uniqid();
        mkdir($tempDir, 0755, true);

        $passJson = $this->buildPassJson($card, 'pass.com.sdb.card', '7YL3972NBW');
        file_put_contents("$tempDir/pass.json", json_encode($passJson, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

        $this->copyAssets($tempDir);

        // Create manifest
        $manifest = [];
        foreach (glob("$tempDir/*") as $file) {
            if (is_file($file)) {
                $manifest[basename($file)] = sha1(file_get_contents($file));
            }
        }
        file_put_contents("$tempDir/manifest.json", json_encode($manifest));

        // Create .pkpass ZIP (unsigned)
        $pkpassPath = "$tempDir/card.pkpass";
        $zip = new \ZipArchive();
        $zip->open($pkpassPath, \ZipArchive::CREATE);
        foreach (glob("$tempDir/*") as $file) {
            if (is_file($file) && basename($file) !== 'card.pkpass') {
                $zip->addFile($file, basename($file));
            }
        }
        $zip->close();

        $content = file_get_contents($pkpassPath);
        array_map('unlink', glob("$tempDir/*"));
        rmdir($tempDir);

        return response($content, 200)
            ->header('Content-Type', 'application/vnd.apple.pkpass')
            ->header('Content-Disposition', 'attachment; filename="sdb_card.pkpass"');
    }

    /**
     * Build pass.json structure
     */
    private function buildPassJson(Card $card, string $passTypeId, string $teamId): array
    {
        $cardNumber = decrypt($card->card_number_encrypted);
        $last4 = substr($cardNumber, -4);
        $expiry = $card->expiry_date ? $card->expiry_date->format('m/Y') : '';

        return [
            'formatVersion' => 1,
            'passTypeIdentifier' => $passTypeId,
            'serialNumber' => 'sdb-card-' . $card->id,
            'teamIdentifier' => $teamId,
            'organizationName' => 'SDB Bank',
            'description' => 'SDB Virtual Card',
            'foregroundColor' => 'rgb(255, 255, 255)',
            'backgroundColor' => 'rgb(30, 94, 255)',
            'labelColor' => 'rgb(200, 220, 255)',
            'generic' => [
                'primaryFields' => [
                    [
                        'key' => 'card_number',
                        'label' => 'CARD NUMBER',
                        'value' => '**** **** **** ' . $last4,
                    ],
                ],
                'secondaryFields' => [
                    [
                        'key' => 'holder',
                        'label' => 'CARD HOLDER',
                        'value' => $card->card_holder_name,
                    ],
                    [
                        'key' => 'expiry',
                        'label' => 'EXPIRES',
                        'value' => $expiry,
                    ],
                ],
                'auxiliaryFields' => [
                    [
                        'key' => 'type',
                        'label' => 'TYPE',
                        'value' => strtoupper(str_replace('virtual_', '', $card->card_type)),
                    ],
                    [
                        'key' => 'status',
                        'label' => 'STATUS',
                        'value' => ucfirst($card->status),
                    ],
                ],
                'backFields' => [
                    [
                        'key' => 'bank',
                        'label' => 'Bank',
                        'value' => 'SDB - Syria Digital Bank',
                    ],
                    [
                        'key' => 'support',
                        'label' => 'Support',
                        'value' => 'info@sdb-bank.com\nhttps://sdb-bank.com',
                    ],
                    [
                        'key' => 'terms',
                        'label' => 'Terms',
                        'value' => 'This virtual card is issued by SDB Bank. Contact support for any issues.',
                    ],
                ],
            ],
            'barcode' => [
                'message' => $cardNumber,
                'format' => 'PKBarcodeFormatQR',
                'messageEncoding' => 'iso-8859-1',
            ],
        ];
    }

    /**
     * Create minimal icon assets for the pass
     */
    private function copyAssets(string $dir): void
    {
        // Generate a simple 29x29 blue icon PNG
        $sizes = ['icon' => 29, 'icon@2x' => 58, 'logo' => 160, 'logo@2x' => 320];

        foreach ($sizes as $name => $size) {
            $img = imagecreatetruecolor($size, $size);
            $blue = imagecolorallocate($img, 30, 94, 255);
            $white = imagecolorallocate($img, 255, 255, 255);
            imagefill($img, 0, 0, $blue);

            // Draw "SDB" text on logo
            if ($size >= 100) {
                $fontSize = (int)($size * 0.3);
                imagestring($img, 5, (int)($size * 0.3), (int)($size * 0.35), 'SDB', $white);
            }

            imagepng($img, "$dir/$name.png");
            imagedestroy($img);
        }
    }
}