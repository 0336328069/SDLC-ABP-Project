#!/bin/bash
set -x

# Script: generate_implement_plan.sh
# Purpose: Generate Function Planning Implementation file for a given feature via AI CLI
# Usage: ./generate_implement_plan.sh <FeatureName>
# Example: ./generate_implement_plan.sh Authentication

set -e

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

BA_DOCS_DIR="./docs/BA"
DEV_DOCS_DIR="./docs/DEV"
PROMPT_TEMPLATE="./prompts/function_planning.md"
OUTPUT_PLAN="${DEV_DOCS_DIR}/ImplementPlan_${FEATURE_NAME}.md"
TMP_PROMPT="./function_planning_${FEATURE_NAME}_$$.md"
TMP_CONTEXT="./context_${FEATURE_NAME}_$$.md"
TMP_FULL_PROMPT="./full_prompt_${FEATURE_NAME}_$$.md"
REQUIRED_BA_DOCS=(
  "SystemArchitectureDesign_${FEATURE_NAME}.md"
  "HighLevelDesign_${FEATURE_NAME}.md"
  "ERD_${FEATURE_NAME}.md"
  "CodeConventionDocument_${FEATURE_NAME}.md"
  "LowLevelDesign_${FEATURE_NAME}.md"
  "API_Swagger_${FEATURE_NAME}.md"
)

# BA docs for planning are actually DEV outputs, so check in DEV
for doc in "${REQUIRED_BA_DOCS[@]}"; do
  if [ ! -f "${DEV_DOCS_DIR}/${doc}" ]; then
    echo "❌ Missing file: ${DEV_DOCS_DIR}/${doc}. Aborting!"
    exit 2
  fi
done

# 2. Prepare dynamic prompt: replace [FeatureName] with actual value
export FEATURE_NAME
envsubst < "$PROMPT_TEMPLATE" > "$TMP_PROMPT"
echo "✅ Dynamic prompt created: $TMP_PROMPT"
echo "--- $TMP_PROMPT content ---"
cat "$TMP_PROMPT"
echo "--- End of $TMP_PROMPT content ---"

# 3. Concatenate context from DEV Docs + llms.txt
cat \
  "${DEV_DOCS_DIR}/SystemArchitectureDesign_${FEATURE_NAME}.md" \
  "${DEV_DOCS_DIR}/HighLevelDesign_${FEATURE_NAME}.md" \
  "${DEV_DOCS_DIR}/ERD_${FEATURE_NAME}.md" \
  "${DEV_DOCS_DIR}/CodeConventionDocument_${FEATURE_NAME}.md" \
  "${DEV_DOCS_DIR}/LowLevelDesign_${FEATURE_NAME}.md" \
  "${DEV_DOCS_DIR}/API_Swagger_${FEATURE_NAME}.md" \
  ./llms.txt > "$TMP_CONTEXT"
echo "✅ Context file created: $TMP_CONTEXT"
echo "--- $TMP_CONTEXT content ---"
cat "$TMP_CONTEXT"
echo "--- End of $TMP_CONTEXT content ---"

# 4. Call AI CLI to generate Implementation Plan
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full prompt prepared: $TMP_FULL_PROMPT"
echo "--- $TMP_FULL_PROMPT content ---"
cat "$TMP_FULL_PROMPT"
echo "--- End of $TMP_FULL_PROMPT content ---"

echo "[DEBUG] Sắp gọi Gemini CLI: gemini   -p \"$TMP_FULL_PROMPT\" > \"$OUTPUT_PLAN\""
gemini -p "$TMP_FULL_PROMPT" > "$OUTPUT_PLAN"
echo "✅ Gemini call finished. Result saved at: $OUTPUT_PLAN"
echo "--- $OUTPUT_PLAN content ---"
cat "$OUTPUT_PLAN"
echo "--- End of $OUTPUT_PLAN content ---"

if [ $? -eq 0 ]; then
  echo "🎉 Successfully generated file: $OUTPUT_PLAN"
else
  echo "❌ Generation failed. Check log or context."
  exit 3
fi

# 5. Cleanup tmp files
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

exit 0
