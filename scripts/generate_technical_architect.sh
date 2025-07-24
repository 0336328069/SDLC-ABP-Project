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
  "US_${FEATURE_NAME}_v1.0.md"
  "Vision_${FEATURE_NAME}_v1.0.md"
  "TechStack.md"
  "team-capabilities-file.md"
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

# 4. Ghép context các file input
cat ${CONTEXT_FILES[@]} > "$TMP_CONTEXT"
echo "✅ Context file đã tạo: $TMP_CONTEXT"
cat "$TMP_CONTEXT"

# 5. Gọi AI CLI để sinh file System Architecture Design
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Đã ghép full prompt: $TMP_FULL_PROMPT"
cat "$TMP_FULL_PROMPT"

echo "[DEBUG] Sắp gọi Gemini CLI: gemini -p \"$TMP_FULL_PROMPT\" > \"$OUTPUT_FILE\""
gemini -p "$TMP_FULL_PROMPT" > "$OUTPUT_FILE"
echo "✅ Đã gọi gemini xong. Kết quả lưu ở: $OUTPUT_FILE"
cat "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
  echo "🎉 Đã sinh thành công file: $OUTPUT_FILE"
else
  echo "❌ Sinh file thất bại. Xem lại log hoặc context."
  exit 3
fi

# 6. Cleanup tmp nếu muốn
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

exit 0 