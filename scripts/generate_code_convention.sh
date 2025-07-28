#!/bin/bash
set -e
set -x

# Script: generate_code_convention.sh
# Purpose: Generate Code Convention Document for a given feature via AI CLI
# Usage: ./generate_code_convention.sh <FeatureName>
# Example: ./generate_code_convention.sh Authentication

# 1. Get and check input variable
FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

BA_DOCS_DIR="./docs/BA"
DEV_DOCS_DIR="./docs/DEV"
PROMPT_TEMPLATE="./prompts/code_convention.md"
OUTPUT_CONVENTION="${DEV_DOCS_DIR}/CodeConventionDocument_${FEATURE_NAME}.md"
TMP_PROMPT="./code_convention_${FEATURE_NAME}_$$.md"
TMP_CONTEXT="./context_code_convention_${FEATURE_NAME}_$$.md"
TMP_FULL_PROMPT="./full_prompt_code_convention_${FEATURE_NAME}_$$.md"
REQUIRED_BA_DOCS=(
  "TechStack.md"
  "team-capabilities-file.md"
)
OPTIONAL_BA_DOCS=(
  "README.md"
)

# 2. Check required files
for doc in "${REQUIRED_BA_DOCS[@]}"; do
  if [ ! -f "${BA_DOCS_DIR}/${doc}" ]; then
    echo "❌ Missing file: ${BA_DOCS_DIR}/${doc}. Aborting!"
    exit 2
  fi
done

# 3. Prepare dynamic prompt: replace [FeatureName] with actual value
export FEATURE_NAME
envsubst < "$PROMPT_TEMPLATE" > "$TMP_PROMPT"
echo "✅ Dynamic prompt created: $TMP_PROMPT"
echo "--- $TMP_PROMPT content ---"
cat "$TMP_PROMPT"
echo "--- End of $TMP_PROMPT content ---"

# 4. Concatenate FULL context from BA Docs + llms.txt + README.md (if exists) (NO LINE LIMIT)
echo "📊 Using FULL content from all files (no line limit)..."
cat \
  "${BA_DOCS_DIR}/TechStack.md" \
  "${BA_DOCS_DIR}/team-capabilities-file.md" \
  ./llms.txt \
  $(for doc in "${OPTIONAL_BA_DOCS[@]}"; do if [ -f "${BA_DOCS_DIR}/$doc" ]; then echo "${BA_DOCS_DIR}/$doc"; fi; done) \
  > "$TMP_CONTEXT"
echo "✅ Full context file created: $TMP_CONTEXT"
echo "📊 Context size: $(wc -c < "$TMP_CONTEXT") bytes"

# 5. Combine prompt and context
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full prompt prepared: $TMP_FULL_PROMPT"

# 6. Call Gemini with fresh session (reset context)
echo "🔄 Calling Gemini API with fresh session..."
echo "📝 Creating new Gemini session to avoid context issues..."
echo "📊 Full prompt size: $(wc -c < "$TMP_FULL_PROMPT") bytes"
gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT" > "$OUTPUT_CONVENTION"

# 7. Check if file was created
if [ -f "$OUTPUT_CONVENTION" ]; then
  echo "✅ File created successfully: $OUTPUT_CONVENTION"
  echo "📄 File content preview:"
  head -n 20 "$OUTPUT_CONVENTION"
else
  echo "❌ File was not created by Gemini. Creating it manually..."
  gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT"
  echo "✅ File created manually: $OUTPUT_CONVENTION"
fi

# 8. Cleanup
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

echo "🎉 Code Convention generation completed: $OUTPUT_CONVENTION"

exit 0 