#!/bin/bash
set -e

# Script: generate_erd.sh
# Purpose: Generate ERD using full content (no line limit)
# Usage: ./generate_erd.sh <FeatureName>
# Example: ./generate_erd.sh Authentication

# 1. Get and check input variable
FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

BA_DOCS_DIR="./docs/BA"
DEV_DOCS_DIR="./docs/DEV"
PROMPT_TEMPLATE="./prompts/erd.md"
OUTPUT_ERD="${DEV_DOCS_DIR}/ERD_${FEATURE_NAME}.md"
TMP_PROMPT="./erd_${FEATURE_NAME}_$$.md"
TMP_CONTEXT="./context_erd_${FEATURE_NAME}_$$.md"
TMP_FULL_PROMPT="./full_prompt_erd_${FEATURE_NAME}_$$.md"

# 2. Check required files
echo "🔍 Checking required files..."
REQUIRED_BA_DOCS=(
  "PRD_${FEATURE_NAME}_v1.0.md"
  "SRS&DM_${FEATURE_NAME}_v1.0.md"
  "TechStack.md"
)

for doc in "${REQUIRED_BA_DOCS[@]}"; do
  if [ ! -f "${BA_DOCS_DIR}/${doc}" ]; then
    echo "❌ Missing file: ${BA_DOCS_DIR}/${doc}. Aborting!"
    exit 2
  fi
done

# 3. Prepare dynamic prompt
export FEATURE_NAME
envsubst < "$PROMPT_TEMPLATE" > "$TMP_PROMPT"
echo "✅ Enhanced prompt created: $TMP_PROMPT"

# 4. Concatenate context from BA Docs + llms.txt
cat \
  "${BA_DOCS_DIR}/PRD_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/SRS&DM_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/TechStack.md" \
  ./llms.txt > "$TMP_CONTEXT"
echo "✅ Context file created: $TMP_CONTEXT"

# 5. Combine prompt and context
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full enhanced prompt prepared: $TMP_FULL_PROMPT"

# 6. Call Gemini with fresh session (reset context)
echo "🔄 Calling Gemini API with fresh session..."
echo "📝 Creating new Gemini session to avoid context issues..."
echo "📊 Full prompt size: $(wc -c < "$TMP_FULL_PROMPT") bytes"
gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT" > "$OUTPUT_ERD"

# 7. Check if file was created
if [ -f "$OUTPUT_ERD" ]; then
  echo "✅ File created successfully: $OUTPUT_ERD"
  echo "📄 File content preview:"
  head -n 20 "$OUTPUT_ERD"
else
  echo "❌ File was not created by Gemini. Creating it manually..."
  gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT"
  echo "✅ File created manually: $OUTPUT_ERD"
fi

# 8. Cleanup
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

echo "🎉 ERD generation completed: $OUTPUT_ERD"
exit 0 