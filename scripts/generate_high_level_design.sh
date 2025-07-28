#!/bin/bash
set -e
set -x

# Script: generate_high_level_design.sh
# Purpose: Generate High-Level Design file for a given feature via AI CLI
# Usage: ./generate_high_level_design.sh <FeatureName>
# Example: ./generate_high_level_design.sh Authentication

# 1. Get and check input variable
FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

BA_DOCS_DIR="./docs/BA"
DEV_DOCS_DIR="./docs/DEV"
PROMPT_TEMPLATE="./prompts/high-level-design.md"
OUTPUT_HLD="${DEV_DOCS_DIR}/HighLevelDesign_${FEATURE_NAME}.md"
TMP_PROMPT="./high_level_design_${FEATURE_NAME}_$$.md"
TMP_CONTEXT="./context_hld_${FEATURE_NAME}_$$.md"
TMP_FULL_PROMPT="./full_prompt_hld_${FEATURE_NAME}_$$.md"
REQUIRED_BA_DOCS=(
  "PRD_${FEATURE_NAME}_v1.0.md"
  "SRS&DM_${FEATURE_NAME}_v1.0.md"
  "TechStack.md"
)
REQUIRED_DEV_DOCS=(
  "Technical_Feasibility_${FEATURE_NAME}.md"
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

# 3. Concatenate FULL context from BA Docs, DEV Docs + llms.txt (NO LINE LIMIT)
echo "📊 Using FULL content from all files (no line limit)..."
cat \
  "${BA_DOCS_DIR}/PRD_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/SRS&DM_${FEATURE_NAME}_v1.0.md" \
  "${BA_DOCS_DIR}/TechStack.md" \
  "${DEV_DOCS_DIR}/Technical_Feasibility_${FEATURE_NAME}.md" \
  ./llms.txt > "$TMP_CONTEXT"
echo "✅ Full context file created: $TMP_CONTEXT"
echo "📊 Context size: $(wc -c < "$TMP_CONTEXT") bytes"

# 4. Combine prompt and context
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full prompt prepared: $TMP_FULL_PROMPT"

# 5. Call Gemini with fresh session (reset context)
echo "🔄 Calling Gemini API with fresh session..."
echo "📝 Creating new Gemini session to avoid context issues..."
echo "📊 Full prompt size: $(wc -c < "$TMP_FULL_PROMPT") bytes"
gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT" > "$OUTPUT_HLD"

# 6. Check result
if [ -s "$OUTPUT_HLD" ]; then
  echo "✅ Gemini call completed successfully!"
  echo "📄 Generated file: $OUTPUT_HLD"
  echo "📊 File size: $(wc -c < "$OUTPUT_HLD") bytes"
  echo "📄 Content preview:"
  head -n 20 "$OUTPUT_HLD"
else
  echo "❌ Gemini call failed or produced empty output."
  exit 3
fi

# 7. Cleanup
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

echo "🎉 High-Level Design generation completed: $OUTPUT_HLD"

exit 0 