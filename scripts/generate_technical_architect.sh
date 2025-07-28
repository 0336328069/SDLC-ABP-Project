#!/bin/bash
set -x

# Script: generate_technical_architect.sh
# Purpose: Generate System Architecture Design file for a given feature via AI CLI
# Usage: ./generate_technical_architect.sh <FeatureName>
# Example: ./generate_technical_architect.sh Authentication

set -e

# 1. Nhận và kiểm tra biến đầu vào
FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Vui lòng truyền tên feature. Usage: $0 <FeatureName>"
  exit 1
fi

BA_DOCS_DIR="./docs/BA"
DEV_DOCS_DIR="./docs/DEV"
PROMPT_TEMPLATE="./prompts/technical-architect.md"
OUTPUT_FILE="${DEV_DOCS_DIR}/System_Architecture_Design_${FEATURE_NAME}.md"
TMP_PROMPT="./technical_architect_${FEATURE_NAME}_$$.md"
TMP_CONTEXT="./context_technical_architect_${FEATURE_NAME}_$$.md"
TMP_FULL_PROMPT="./full_prompt_technical_architect_${FEATURE_NAME}_$$.md"
REQUIRED_BA_DOCS=(
  "PRD_${FEATURE_NAME}_v1.0.md"
  "SRS&DM_${FEATURE_NAME}_v1.0.md"
  "TechStack.md"
)
REQUIRED_DEV_DOCS=(
  "Technical_Feasibility_${FEATURE_NAME}.md"
)

# 2. Kiểm tra sự tồn tại của các file bắt buộc
for doc in "${REQUIRED_BA_DOCS[@]}"; do
  if [ ! -f "${BA_DOCS_DIR}/${doc}" ]; then
    echo "❌ Thiếu file: ${BA_DOCS_DIR}/${doc}. Dừng quá trình!"
    exit 2
  fi
  CONTEXT_FILES+=("${BA_DOCS_DIR}/${doc}")
done
for doc in "${REQUIRED_DEV_DOCS[@]}"; do
  if [ ! -f "${DEV_DOCS_DIR}/${doc}" ]; then
    echo "❌ Thiếu file: ${DEV_DOCS_DIR}/${doc}. Dừng quá trình!"
    exit 2
  fi
  CONTEXT_FILES+=("${DEV_DOCS_DIR}/${doc}")
done
if [ ! -f ./llms.txt ]; then
  echo "❌ Thiếu file: ./llms.txt. Dừng quá trình!"
  exit 2
fi
CONTEXT_FILES+=("./llms.txt")

# 3. Chuẩn bị prompt động: thay [FeatureName] bằng giá trị thực tế
export FEATURE_NAME
envsubst < "$PROMPT_TEMPLATE" > "$TMP_PROMPT"
echo "✅ Prompt động đã tạo: $TMP_PROMPT"
cat "$TMP_PROMPT"

# 4. Concatenate FULL context from BA Docs + llms.txt (NO LINE LIMIT)
echo "📊 Using FULL content from all files (no line limit)..."
cat ${CONTEXT_FILES[@]} > "$TMP_CONTEXT"
echo "✅ Full context file created: $TMP_CONTEXT"
echo "📊 Context size: $(wc -c < "$TMP_CONTEXT") bytes"

# 5. Combine prompt and context
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Full prompt prepared: $TMP_FULL_PROMPT"

# 6. Call Gemini with fresh session (reset context)
echo "🔄 Calling Gemini API with fresh session..."
echo "📝 Creating new Gemini session to avoid context issues..."
echo "📊 Full prompt size: $(wc -c < "$TMP_FULL_PROMPT") bytes"
gemini -y -m gemini-2.5-flash -p "$TMP_FULL_PROMPT" > "$OUTPUT_FILE"

# 7. Check result
if [ -s "$OUTPUT_FILE" ]; then
  echo "✅ Gemini call completed successfully!"
  echo "📄 Generated file: $OUTPUT_FILE"
  echo "📊 File size: $(wc -c < "$OUTPUT_FILE") bytes"
  echo "📄 Content preview:"
  head -n 20 "$OUTPUT_FILE"
else
  echo "❌ Gemini call failed or produced empty output."
  exit 3
fi

# 8. Cleanup
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

echo "🎉 Technical Architecture generation completed: $OUTPUT_FILE"

exit 0 