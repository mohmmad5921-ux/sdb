/// MRZ (Machine Readable Zone) parser for passports and ID cards.
/// Supports TD3 (passport, 2×44) and TD1 (ID card, 3×30) formats.
class MrzParser {
  /// Parse MRZ from OCR text. Returns extracted data map or null.
  static Map<String, String>? parse(String ocrText) {
    // Clean up OCR artifacts
    final cleaned = ocrText
        .replaceAll('«', '<')
        .replaceAll('‹', '<')
        .replaceAll('›', '<')
        .replaceAll('»', '<')
        .replaceAll('O', '0') // common OCR mistake in MRZ
        .replaceAll(' ', '');

    final lines = cleaned
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.length >= 28)
        .toList();

    // Try TD3 (Passport): 2 lines of 44 chars
    final td3Lines = lines.where((l) => l.length >= 42 && l.length <= 46 && l.contains('<<')).toList();
    if (td3Lines.length >= 2) {
      final result = _parseTD3(_normalizeLine(td3Lines[0], 44), _normalizeLine(td3Lines[1], 44));
      if (result != null) return result;
    }

    // Try TD1 (ID Card): 3 lines of 30 chars
    final td1Lines = lines.where((l) => l.length >= 28 && l.length <= 32).toList();
    if (td1Lines.length >= 3) {
      final result = _parseTD1(
        _normalizeLine(td1Lines[0], 30),
        _normalizeLine(td1Lines[1], 30),
        _normalizeLine(td1Lines[2], 30),
      );
      if (result != null) return result;
    }

    // Try TD2 (some residence permits): 2 lines of 36 chars
    final td2Lines = lines.where((l) => l.length >= 34 && l.length <= 38 && l.contains('<<')).toList();
    if (td2Lines.length >= 2) {
      final result = _parseTD2(_normalizeLine(td2Lines[0], 36), _normalizeLine(td2Lines[1], 36));
      if (result != null) return result;
    }

    return null;
  }

  /// Normalize line to exact length
  static String _normalizeLine(String line, int len) {
    // Fix common OCR errors in MRZ
    line = line.replaceAll(RegExp(r'[^A-Z0-9<]'), '<');
    if (line.length > len) line = line.substring(0, len);
    if (line.length < len) line = line.padRight(len, '<');
    return line;
  }

  /// TD3 Passport format (2 lines × 44 chars)
  /// Line 1: P<CTRYNAME<<FIRSTNAME<MIDDLENAME<<<<<<<<
  /// Line 2: DOCNUMBER_CNTRDOB_SEXEXPIRY_____________CK
  static Map<String, String>? _parseTD3(String line1, String line2) {
    if (line1.length != 44 || line2.length != 44) return null;
    if (!line1.startsWith('P')) return null;

    final docType = 'passport';
    final nationality = _countryName(line1.substring(2, 5));
    final namePart = line1.substring(5);
    final names = _extractNames(namePart);

    final docNumber = line2.substring(0, 9).replaceAll('<', '');
    final nationalityCode2 = line2.substring(10, 13);
    final dob = _formatDate(line2.substring(13, 19));
    final sex = _formatSex(line2[20]);
    final expiry = _formatDate(line2.substring(21, 27));

    if (docNumber.isEmpty || dob == null) return null;

    return {
      'document_type': docType,
      'document_number': docNumber,
      'nationality': nationality ?? _countryName(nationalityCode2) ?? nationalityCode2,
      'nationality_code': line1.substring(2, 5).replaceAll('<', ''),
      'full_name': names['full'] ?? '',
      'first_name': names['first'] ?? '',
      'last_name': names['last'] ?? '',
      'date_of_birth': dob,
      'sex': sex,
      'expiry_date': expiry ?? '',
    };
  }

  /// TD1 ID Card format (3 lines × 30 chars)
  /// Line 1: I<CTRYDOCNUMBER<<<<<<<<<<<<CK
  /// Line 2: DOB_SEX_EXPIRY_NATIONALITY_CK
  /// Line 3: NAME<<FIRSTNAME<<<<<<<<<<<<<
  static Map<String, String>? _parseTD1(String line1, String line2, String line3) {
    if (line1.length != 30 || line2.length != 30 || line3.length != 30) return null;

    final typeChar = line1[0];
    if (typeChar != 'I' && typeChar != 'A' && typeChar != 'C') return null;

    final docType = typeChar == 'I' ? 'id_card' : 'residence';
    final countryCode = line1.substring(2, 5).replaceAll('<', '');
    final docNumber = line1.substring(5, 14).replaceAll('<', '');

    final dob = _formatDate(line2.substring(0, 6));
    final sex = _formatSex(line2[7]);
    final expiry = _formatDate(line2.substring(8, 14));
    final nationalityCode = line2.substring(15, 18).replaceAll('<', '');

    final names = _extractNames(line3);

    if (docNumber.isEmpty) return null;

    return {
      'document_type': docType,
      'document_number': docNumber,
      'nationality': _countryName(nationalityCode) ?? _countryName(countryCode) ?? nationalityCode,
      'nationality_code': nationalityCode.isNotEmpty ? nationalityCode : countryCode,
      'full_name': names['full'] ?? '',
      'first_name': names['first'] ?? '',
      'last_name': names['last'] ?? '',
      'date_of_birth': dob ?? '',
      'sex': sex,
      'expiry_date': expiry ?? '',
    };
  }

  /// TD2 format (2 lines × 36 chars) — some residence permits
  static Map<String, String>? _parseTD2(String line1, String line2) {
    if (line1.length != 36 || line2.length != 36) return null;

    final typeChar = line1[0];
    if (typeChar != 'I' && typeChar != 'A' && typeChar != 'C' && typeChar != 'P') return null;

    final docType = 'residence';
    final countryCode = line1.substring(2, 5).replaceAll('<', '');
    final names = _extractNames(line1.substring(5));

    final docNumber = line2.substring(0, 9).replaceAll('<', '');
    final nationalityCode = line2.substring(10, 13).replaceAll('<', '');
    final dob = _formatDate(line2.substring(13, 19));
    final sex = _formatSex(line2[20]);
    final expiry = _formatDate(line2.substring(21, 27));

    if (docNumber.isEmpty) return null;

    return {
      'document_type': docType,
      'document_number': docNumber,
      'nationality': _countryName(nationalityCode) ?? _countryName(countryCode) ?? nationalityCode,
      'nationality_code': nationalityCode.isNotEmpty ? nationalityCode : countryCode,
      'full_name': names['full'] ?? '',
      'first_name': names['first'] ?? '',
      'last_name': names['last'] ?? '',
      'date_of_birth': dob ?? '',
      'sex': sex,
      'expiry_date': expiry ?? '',
    };
  }

  /// Extract first and last names from MRZ name field
  static Map<String, String> _extractNames(String namePart) {
    final parts = namePart.split('<<');
    final lastName = parts.isNotEmpty ? parts[0].replaceAll('<', ' ').trim() : '';
    final firstName = parts.length > 1 ? parts[1].replaceAll('<', ' ').trim() : '';
    final full = firstName.isNotEmpty ? '$firstName $lastName' : lastName;
    return {'first': firstName, 'last': lastName, 'full': full};
  }

  /// Format YYMMDD → YYYY-MM-DD
  static String? _formatDate(String raw) {
    if (raw.length != 6) return null;
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 6) return null;

    final yy = int.tryParse(digits.substring(0, 2));
    final mm = int.tryParse(digits.substring(2, 4));
    final dd = int.tryParse(digits.substring(4, 6));
    if (yy == null || mm == null || dd == null) return null;
    if (mm < 1 || mm > 12 || dd < 1 || dd > 31) return null;

    final year = yy > 50 ? 1900 + yy : 2000 + yy;
    return '$year-${mm.toString().padLeft(2, '0')}-${dd.toString().padLeft(2, '0')}';
  }

  /// Format sex character
  static String _formatSex(String ch) {
    return switch (ch) { 'M' => 'ذكر', 'F' => 'أنثى', _ => '' };
  }

  /// ISO 3166-1 alpha-3 → Arabic country name
  static String? _countryName(String code) {
    const map = {
      'SYR': 'سوريا', 'LBN': 'لبنان', 'JOR': 'الأردن', 'IRQ': 'العراق',
      'SAU': 'السعودية', 'ARE': 'الإمارات', 'EGY': 'مصر', 'KWT': 'الكويت',
      'QAT': 'قطر', 'BHR': 'البحرين', 'OMN': 'عُمان', 'YEM': 'اليمن',
      'PSE': 'فلسطين', 'SDN': 'السودان', 'LBY': 'ليبيا', 'TUN': 'تونس',
      'DZA': 'الجزائر', 'MAR': 'المغرب', 'MRT': 'موريتانيا',
      'DNK': 'الدنمارك', 'SWE': 'السويد', 'NOR': 'النرويج', 'FIN': 'فنلندا',
      'DEU': 'ألمانيا', 'D<<': 'ألمانيا', 'FRA': 'فرنسا', 'GBR': 'بريطانيا',
      'NLD': 'هولندا', 'BEL': 'بلجيكا', 'AUT': 'النمسا', 'CHE': 'سويسرا',
      'ITA': 'إيطاليا', 'ESP': 'إسبانيا', 'PRT': 'البرتغال', 'GRC': 'اليونان',
      'TUR': 'تركيا', 'USA': 'أمريكا', 'CAN': 'كندا', 'AUS': 'أستراليا',
      'IND': 'الهند', 'PAK': 'باكستان', 'AFG': 'أفغانستان', 'IRN': 'إيران',
      'RUS': 'روسيا', 'CHN': 'الصين', 'JPN': 'اليابان', 'KOR': 'كوريا',
      'BRA': 'البرازيل', 'MEX': 'المكسيك', 'ARG': 'الأرجنتين',
      'POL': 'بولندا', 'CZE': 'التشيك', 'ROU': 'رومانيا', 'HUN': 'المجر',
      'BGR': 'بلغاريا', 'HRV': 'كرواتيا', 'SRB': 'صربيا', 'UKR': 'أوكرانيا',
      'GEO': 'جورجيا', 'ARM': 'أرمينيا', 'AZE': 'أذربيجان',
      'SOM': 'الصومال', 'ETH': 'إثيوبيا', 'ERI': 'إريتريا', 'KEN': 'كينيا',
      'NGA': 'نيجيريا', 'GHA': 'غانا', 'ZAF': 'جنوب أفريقيا',
      'LUX': 'لوكسمبورغ', 'IRL': 'أيرلندا', 'ISL': 'آيسلندا',
      'LTU': 'ليتوانيا', 'LVA': 'لاتفيا', 'EST': 'إستونيا',
      'SVK': 'سلوفاكيا', 'SVN': 'سلوفينيا', 'MLT': 'مالطا', 'CYP': 'قبرص',
    };
    final c = code.replaceAll('<', '').toUpperCase();
    return map[c];
  }

  /// Get document type label in Arabic
  static String docTypeLabel(String? type) {
    return switch (type) {
      'passport' => 'جواز سفر',
      'id_card' => 'بطاقة هوية',
      'residence' => 'بطاقة إقامة',
      _ => 'مستند',
    };
  }
}
