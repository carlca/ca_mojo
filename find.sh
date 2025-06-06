find . -type f \
-not -path '*/.git/*' \
-not -path '*/.magic/*' \
-not -path '*/.pixi/*' \
-not -path '*/ruff_cache/*' \
\( \
  -iname "*.txt" -o \
  -iname "*.md" -o \
  -iname "*.mojo" -o \
  -iname "*.js" -o \
  -iname "*.ts" -o \
  -iname "*.json" -o \
  -iname "*.xml" -o \
  -iname "*.html" -o \
  -iname "*.css" -o \
  -iname "*.yml" -o \
  -iname "*.yaml" -o \
  -iname "*.toml" \
\) \
-print0 | xargs -0 -I {} sh -c 'echo "--- FILE: {} ---"; cat {}; echo "\n"' | pbcopy
