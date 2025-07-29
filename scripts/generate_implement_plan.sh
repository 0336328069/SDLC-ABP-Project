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
  "TechStack.md"
)
REQUIRED_DEV_DOCS=(
  "HighLevelDesign_${FEATURE_NAME}.md"
  "LowLevelDesign_${FEATURE_NAME}.md"
  "ERD_${FEATURE_NAME}.md"
  "CodeConventionDocument_${FEATURE_NAME}.md"
)
OPTIONAL_DEV_DOCS=(
  "README.md"
)

# 1. Check required files
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
if [ ! -f ./llms.txt ]; then
  echo "❌ Missing file: ./llms.txt. Aborting!"
  exit 2
fi

# 2. Prepare dynamic prompt: replace [FeatureName] with actual value
export FEATURE_NAME
envsubst < "$PROMPT_TEMPLATE" > "$TMP_PROMPT"
echo "✅ Dynamic prompt created: $TMP_PROMPT"
echo "--- $TMP_PROMPT content ---"
cat "$TMP_PROMPT"
echo "--- End of $TMP_PROMPT content ---"

# 3. Concatenate OPTIMIZED context (first 300 lines of each file to reduce size)
echo "📊 Using OPTIMIZED content (first 300 lines per file) to reduce input size..."
head -n 300 "${DEV_DOCS_DIR}/HighLevelDesign_${FEATURE_NAME}.md" > "$TMP_CONTEXT"
echo -e "\n\n=== LowLevelDesign Content ===" >> "$TMP_CONTEXT"
head -n 300 "${DEV_DOCS_DIR}/LowLevelDesign_${FEATURE_NAME}.md" >> "$TMP_CONTEXT"
echo -e "\n\n=== ERD Content ===" >> "$TMP_CONTEXT"
head -n 300 "${DEV_DOCS_DIR}/ERD_${FEATURE_NAME}.md" >> "$TMP_CONTEXT"
echo -e "\n\n=== CodeConvention Content ===" >> "$TMP_CONTEXT"
head -n 300 "${DEV_DOCS_DIR}/CodeConventionDocument_${FEATURE_NAME}.md" >> "$TMP_CONTEXT"
echo -e "\n\n=== TechStack Content ===" >> "$TMP_CONTEXT"
head -n 300 "${BA_DOCS_DIR}/TechStack.md" >> "$TMP_CONTEXT"
echo -e "\n\n=== LLMs Content ===" >> "$TMP_CONTEXT"
head -n 100 ./llms.txt >> "$TMP_CONTEXT"

# Add README.md if exists (optional)
if [ -f "${DEV_DOCS_DIR}/README.md" ]; then
  echo -e "\n\n=== README Content ===" >> "$TMP_CONTEXT"
  head -n 200 "${DEV_DOCS_DIR}/README.md" >> "$TMP_CONTEXT"
fi

echo "✅ Optimized context file created: $TMP_CONTEXT"
echo "📊 Context size: $(wc -c < "$TMP_CONTEXT") bytes"

# 4. Combine prompt and context
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full prompt prepared: $TMP_FULL_PROMPT"

# 5. Call Gemini with fresh session (reset context)
echo "🔄 Calling Gemini API with fresh session..."
echo "📝 Creating new Gemini session to avoid context issues..."
echo "📊 Optimized prompt size: $(wc -c < "$TMP_FULL_PROMPT") bytes"
gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT" > "$OUTPUT_PLAN"

# 6. Check if file was created
if [ -f "$OUTPUT_PLAN" ]; then
  echo "✅ File created successfully: $OUTPUT_PLAN"
  echo "📄 File content preview:"
  head -n 20 "$OUTPUT_PLAN"
else
  echo "❌ File was not created by Gemini. Creating it manually..."
  gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT"
  echo "✅ File created manually: $OUTPUT_PLAN"
fi

# 7. Cleanup
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

echo "🎉 Implementation Plan generation completed: $OUTPUT_PLAN"

exit 0
