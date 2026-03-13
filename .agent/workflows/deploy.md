---
description: Deploy to Simply.com production server
---
// turbo-all

## Steps

1. Commit and push all changes:
```bash
cd /Users/mohammad/sdb && git add -A && git commit -m "deploy" && git push origin main
```

2. Deploy on server (pulls code, builds frontend, clears cache):
```bash
ssh sdb-bank.com@linux132.unoeuro.com "cd sdb && bash deploy.sh"
```

## Notes
- The `deploy.sh` script on the server handles: git pull, npm run build, cache clearing
- Always use this workflow instead of manual git pull to avoid blank page issues
- The blank page bug happens when `git pull` updates blade files (which reference new asset filenames) without rebuilding frontend assets
