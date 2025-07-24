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
  "PRD_${FEATURE_NAME}_v1.0.md"
  "SRS&DM_${FEATURE_NAME}_v1.0.md"
  "US_${FEATURE_NAME}_v1.0.md"
  "Vision_${FEATURE_NAME}_v1.0.md"
  "TechStack.md"
  "team-capabilities-file.md"
)
REQUIRED_DEV_DOCS=(
  "Technical_Feasibility_${FEATURE_NAME}.md"
  "HighLevelDesign_${FEATURE_NAME}.md"
)
OPTIONAL_DEV_DOCS=(
  "ExistingCodeConvention_${FEATURE_NAME}.md"
)

echo "🔍 Checking BA Docs for feature: $FEATURE_NAME ..."
for doc in "${REQUIRED_BA_DOCS[@]}"; do
  if [ ! -f "${BA_DOCS_DIR}/${doc}" ]; then
    echo "❌ Missing file: ${BA_DOCS_DIR}/${doc}. Aborting!"
    exit 2
  fi
done
echo "🔍 Checking DEV Docs for feature: $FEATURE_NAME ..."
for doc in "${REQUIRED_DEV_DOCS[@]}"; do
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

# 3. Concatenate context from BA Docs, DEV Docs + llms.txt
cat \
  "${BA_DOCS_DIR}/PRD_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/SRS&DM_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/US_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/Vision_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/TechStack.md" \
  "${BA_DOCS_DIR}/team-capabilities-file.md" \
  "${DEV_DOCS_DIR}/Technical_Feasibility_${FEATURE_NAME}.md" \
  "${DEV_DOCS_DIR}/HighLevelDesign_${FEATURE_NAME}.md" \
  ./llms.txt \
  $(for doc in "${OPTIONAL_DEV_DOCS[@]}"; do if [ -f "${DEV_DOCS_DIR}/$doc" ]; then echo "${DEV_DOCS_DIR}/$doc"; fi; done) \
  > "$TMP_CONTEXT"
echo "✅ Context file created: $TMP_CONTEXT"
echo "--- $TMP_CONTEXT content ---"
cat "$TMP_CONTEXT"
echo "--- End of $TMP_CONTEXT content ---"

# 4. Call AI CLI to generate Code Convention Document
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full prompt prepared: $TMP_FULL_PROMPT"
echo "--- $TMP_FULL_PROMPT content ---"
cat "$TMP_FULL_PROMPT"
echo "--- End of $TMP_FULL_PROMPT content ---"

gemini -p "$TMP_FULL_PROMPT" > "$OUTPUT_CONVENTION"
echo "✅ Gemini call finished. Result saved at: $OUTPUT_CONVENTION"
echo "--- $OUTPUT_CONVENTION content ---"
cat "$OUTPUT_CONVENTION"
echo "--- End of $OUTPUT_CONVENTION content ---"

if [ $? -eq 0 ]; then
  echo "🎉 Successfully generated file: $OUTPUT_CONVENTION"
else
  echo "❌ Generation failed. Check log or context."
  exit 3
fi

# 5. Cleanup tmp files
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

exit 0 