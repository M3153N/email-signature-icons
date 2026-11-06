#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_dir/source"
dist_dir="$repo_dir/dist"
preview_dir="$repo_dir/preview"

command -v magick >/dev/null || {
  echo "Error: ImageMagick (magick) is required." >&2
  exit 1
}

rm -rf "$dist_dir"
mkdir -p "$preview_dir"

styles=(baseline b4-dark b4-light)
sizes=(16 20 24 32)
icons=(b4 linkedin mail whatsapp)

for style in "${styles[@]}"; do
  for size in "${sizes[@]}"; do
    mkdir -p "$dist_dir/$style/$size"
    for icon in "${icons[@]}"; do
      input="$source_dir/$style/$icon.png"
      output="$dist_dir/$style/$size/$icon.png"
      dimensions="$(magick identify -format '%w %h' "$input")"
      read -r width height <<<"$dimensions"
      square=$(( width > height ? width : height ))

      # Center on a transparent square, then resize with high-quality Lanczos.
      # ImageMagick performs alpha-aware filtering and retains the alpha channel.
      magick "$input" \
        -alpha on -background none -gravity center -extent "${square}x${square}" \
        -filter Lanczos -resize "${size}x${size}!" \
        "$output"
    done
  done
done

# Contact sheet at an enlarged display scale; labels make all 48 outputs auditable.
tiles=()
for style in "${styles[@]}"; do
  for size in "${sizes[@]}"; do
    for icon in "${icons[@]}"; do
      src="$dist_dir/$style/$size/$icon.png"
      tile="${TMPDIR:-/tmp}/email-icon-${style}-${size}-${icon}.png"
      magick "$src" -filter point -resize 96x96 \
        -background '#f1f3f5' -gravity center -extent 180x126 \
        -fill '#202124' -font Helvetica -pointsize 12 \
        -gravity south -annotate +0+8 "$style · ${size}px · $icon" "$tile"
      tiles+=("$tile")
    done
  done
done

magick montage "${tiles[@]}" -tile 4x12 -geometry +4+4 \
  -background '#dfe3e7' "$preview_dir/contact-sheet.png"
rm -f "${tiles[@]}"

echo "Generated 48 icons and preview/contact-sheet.png"
