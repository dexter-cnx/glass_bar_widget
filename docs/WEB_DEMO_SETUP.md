# Web Demo Setup

## GitHub Pages

1. Push this repository to GitHub.
2. Open repository settings.
3. Go to **Pages**.
4. Set source to **GitHub Actions**.
5. Push to the default branch.
6. Wait for the `Web Demo` workflow to finish.

## Base href

The current workflow uses:

```bash
--base-href /glass_bar_widget/
```

If your repository name is different, update `.github/workflows/web-demo.yml`.
