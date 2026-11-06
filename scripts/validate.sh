#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dist_dir="$repo_dir/dist"

command -v magick >/dev/null || {
  echo "Error: ImageMagick (magick) is required." >&2
  exit 1
}

mapfile -d '' files < <(find "$dist_dir" -type f -name '*.png' -print0 | sort -z)
[[ ${#files[@]} -eq 72 ]] || {
  echo "Error: expected 72 PNG files, found ${#files[@]}." >&2
  exit 1
}

for file in "${files[@]}"; do
  rel="${file#"$dist_dir/"}"
  size="$(cut -d/ -f2 <<<"$rel")"
  geometry="$(magick identify -format '%wx%h' "$file")"
  channels="$(magick identify -format '%[channels]' "$file")"
  [[ "$geometry" == "${size}x${size}" ]] || {
    echo "Error: $rel is $geometry, expected ${size}x${size}." >&2
    exit 1
  }
  [[ "$channels" == *a* ]] || {
    echo "Error: $rel has no alpha channel ($channels)." >&2
    exit 1
  }
  magick "$file" null: 2>/dev/null || {
    echo "Error: unable to decode $rel." >&2
    exit 1
  }
done

echo "Validation passed: 72 readable PNGs, correct dimensions, alpha preserved."
