#!/bin/bash
set -x

# Script: generate_implement_plan.sh
# Purpose: Generate Function Planning Implementation file for a given feature via AI CLI
# Usage: ./generate_implement_plan.sh <FeatureName>
# Example: ./generate_implement_plan.sh Authentication

set -e

# 1. Nhận và kiểm tra biến đầu vào
FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Vui lòng truyền tên feature. Usage: $0 <FeatureName>"
  exit 1
fi

DEV_DOCS_DIR="./docs/DEV"
PROMPT_TEMPLATE="./prompts/function_planning.md"
OUTPUT_PLAN="${DEV_DOCS_DIR}/ImplementPlan_${FEATURE_NAME}_v1.0.md"
TMP_PROMPT="./function_planning_${FEATURE_NAME}_$$.md"
TMP_CONTEXT="./context_${FEATURE_NAME}_$$.md"
TMP_FULL_PROMPT="./full_prompt_${FEATURE_NAME}_$$.md"
REQUIRED_DOCS=(
  "SystemArchitectureDesign_${FEATURE_NAME}_v1.0.md"
  "HighLevelDesign_${FEATURE_NAME}_v1.0.md"
  "ERD_${FEATURE_NAME}_v1.0.md"
  "CodeConventionDocument_${FEATURE_NAME}_v1.0.md"
  "LowLevelDesign_${FEATURE_NAME}_v1.0.md"
  "API_Swagger_${FEATURE_NAME}_v1.0.md"
)

echo "🔍 Checking Dev Docs for feature: $FEATURE_NAME ..."

for doc in "${REQUIRED_DOCS[@]}"; do
  if [ ! -f "${DEV_DOCS_DIR}/${doc}" ]; then
    echo "❌ Thiếu file: ${DEV_DOCS_DIR}/${doc}. Dừng quá trình!"
    exit 2
  fi
done

# 2. Chuẩn bị prompt động: thay [FeatureName] bằng giá trị thực tế
export FEATURE_NAME
envsubst < "$PROMPT_TEMPLATE" > "$TMP_PROMPT"
echo "✅ Prompt động đã tạo: $TMP_PROMPT"
echo "--- Nội dung $TMP_PROMPT ---"
cat "$TMP_PROMPT"
echo "--- Hết nội dung $TMP_PROMPT ---"

# 3. Ghép context các Dev Doc + llms.txt
cat "${DEV_DOCS_DIR}/SystemArchitectureDesign_${FEATURE_NAME}_v1.0.md" \
    "${DEV_DOCS_DIR}/HighLevelDesign_${FEATURE_NAME}_v1.0.md" \
    "${DEV_DOCS_DIR}/ERD_${FEATURE_NAME}_v1.0.md" \
    "${DEV_DOCS_DIR}/CodeConventionDocument_${FEATURE_NAME}_v1.0.md" \
    "${DEV_DOCS_DIR}/LowLevelDesign_${FEATURE_NAME}_v1.0.md" \
    "${DEV_DOCS_DIR}/API_Swagger_${FEATURE_NAME}_v1.0.md" \
    ./llms.txt > "$TMP_CONTEXT"
echo "✅ Context file đã tạo: $TMP_CONTEXT"
echo "--- Nội dung $TMP_CONTEXT ---"
cat "$TMP_CONTEXT"
echo "--- Hết nội dung $TMP_CONTEXT ---"

# 4. Gọi AI CLI để sinh file Implementation Plan
cat "$TMP_PROMPT" "$TMP_CONTEXT" > "$TMP_FULL_PROMPT"
echo "✅ Đã ghép full prompt: $TMP_FULL_PROMPT"
echo "--- Nội dung $TMP_FULL_PROMPT ---"
cat "$TMP_FULL_PROMPT"
echo "--- Hết nội dung $TMP_FULL_PROMPT ---"

gemini -p "$TMP_FULL_PROMPT" > "$OUTPUT_PLAN"
echo "✅ Đã gọi gemini xong. Kết quả lưu ở: $OUTPUT_PLAN"
echo "--- Nội dung $OUTPUT_PLAN ---"
cat "$OUTPUT_PLAN"
echo "--- Hết nội dung $OUTPUT_PLAN ---"

if [ $? -eq 0 ]; then
  echo "🎉 Đã sinh thành công file: $OUTPUT_PLAN"
else
  echo "❌ Sinh file thất bại. Xem lại log hoặc context."
  exit 3
fi

# 5. Cleanup tmp nếu muốn
rm -f "$TMP_PROMPT" "$TMP_CONTEXT" "$TMP_FULL_PROMPT"

exit 0
