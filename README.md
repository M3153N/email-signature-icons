# Email Signature Icons

PNG icons prepared for professional email signatures, including Gmail. The repository contains reproducible source assets and high-quality Lanczos exports with preserved transparency.

## Available files

- Styles: `baseline`, `b4-dark`, and `b4-light`
- Icons: `b4.png`, `linkedin.png`, `mail.png`, and `whatsapp.png`
- Pixel sizes: 16×16, 20×20, 24×24, 32×32, and 48×48
- Output: `dist/<style>/<size>/<icon>.png` (60 PNGs total)
- Originals used for regeneration: `source/<style>/<icon>.png`
- Visual review sheet: `preview/contact-sheet.png`

## Regenerate and validate

ImageMagick 7 (`magick`) is the only required image dependency.

```bash
./scripts/generate.sh
./scripts/validate.sh
```

The generator centers non-square input on a transparent square canvas before resizing. It never edits files under `source/`.

## Direct CDN URLs

jsDelivr serves the public GitHub repository directly. For example:

```text
https://cdn.jsdelivr.net/gh/M3153N/email-signature-icons@main/dist/baseline/24/mail.png
```

See [`URLS.md`](URLS.md) for every URL, including version-pinned alternatives. CDN cache propagation can take a short while after a push or tag update.

## Gmail recommendations

Use 20px or 24px files for most signatures, and test both light and dark viewing contexts. Host the PNG through a stable version-pinned CDN URL. In HTML, the image's intrinsic pixel dimensions and its display dimensions are different: a 24×24 file can be rendered at another size using `width` and `height`, but displaying it at its native dimensions generally gives the most predictable result.

## Trademarks and rights

Brand names and icons are the property of their respective owners. Their inclusion does not claim ownership, endorsement, or any unverified license. Confirm that you have the rights required for your intended public and commercial use.
