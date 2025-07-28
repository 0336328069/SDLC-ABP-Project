#!/bin/bash
set -e
set -x

# Script: generate_api_swagger.sh
# Purpose: Generate API Swagger (OpenAPI) YAML file for a given feature via AI CLI
# Usage: ./generate_api_swagger.sh <FeatureName>
# Example: ./generate_api_swagger.sh Authentication

# 1. Get and check input variable
FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

BA_DOCS_DIR="./docs/BA"
DEV_DOCS_DIR="./docs/DEV"
PROMPT_TEMPLATE="./prompts/api-swagger.md"
OUTPUT_API_SWAGGER="${DEV_DOCS_DIR}/API_Swagger_${FEATURE_NAME}.yaml"
TMP_PROMPT="./api_swagger_${FEATURE_NAME}_$$.md"
TMP_CONTEXT="./context_api_swagger_${FEATURE_NAME}_$$.md"
TMP_FULL_PROMPT="./full_prompt_api_swagger_${FEATURE_NAME}_$$.md"
REQUIRED_BA_DOCS=(
  "TechStack.md"
)
REQUIRED_DEV_DOCS=(
  "CodeConventionDocument_${FEATURE_NAME}.md"
  "LowLevelDesign_${FEATURE_NAME}.md"
)

# 2. Check required files
for doc in "${REQUIRED_BA_DOCS[@]}"; do
  if [ ! -f "${BA_DOCS_DIR}/${doc}" ]; then
    echo "❌ Missing file: ${BA_DOCS_DIR}/${doc}. Aborting!"
    exit 2
  fi
done
for doc in "${REQUIRED_DEV_DOCS[@]}"; do
  if [ ! -f "${DEV_DOCS_DIR}/${doc}" ]; then
    echo "❌ Missing file: ${DEV_DOCS_DIR}/${doc}. Aborting!"
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

# 4. Concatenate FULL context from BA Docs, DEV Docs + llms.txt (NO LINE LIMIT)
echo "📊 Using FULL content from all files (no line limit)..."
cat \
  "${BA_DOCS_DIR}/TechStack.md" \
  "${DEV_DOCS_DIR}/CodeConventionDocument_${FEATURE_NAME}.md" \
  "${DEV_DOCS_DIR}/LowLevelDesign_${FEATURE_NAME}.md" \
  ./llms.txt > "$TMP_CONTEXT"
echo "✅ Full context file created: $TMP_CONTEXT"
echo "📊 Context size: $(wc -c < "$TMP_CONTEXT") bytes"

# 5. Combine prompt and context
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full prompt prepared: $TMP_FULL_PROMPT"

# 6. Call Gemini with fresh session (reset context)
echo "🔄 Calling Gemini API with fresh session..."
echo "📝 Creating new Gemini session to avoid context issues..."
echo "📊 Full prompt size: $(wc -c < "$TMP_FULL_PROMPT") bytes"
gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT" > "$OUTPUT_API_SWAGGER"

# 7. Check result
if [ -s "$OUTPUT_API_SWAGGER" ]; then
  echo "✅ Gemini call completed successfully!"
  echo "📄 Generated file: $OUTPUT_API_SWAGGER"
  echo "📊 File size: $(wc -c < "$OUTPUT_API_SWAGGER") bytes"
  echo "📄 Content preview:"
  head -n 20 "$OUTPUT_API_SWAGGER"
else
  echo "❌ Gemini call failed or produced empty output."
  exit 3
fi

# 8. Cleanup
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

echo "🎉 API Swagger generation completed: $OUTPUT_API_SWAGGER"

exit 0 