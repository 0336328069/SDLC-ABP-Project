#!/bin/bash

# Script: generate_api_swagger.sh
# Purpose: Generate API Swagger/OpenAPI specification for a given feature
# Usage: ./generate_api_swagger.sh <FeatureName>
# Example: ./generate_api_swagger.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating API Swagger specification for feature: $FEATURE_NAME"

# Call AI with simple prompt - AI will automatically read all reference files
# gemini -y -m gemini-2.5-flash -p "Generate API Swagger/OpenAPI specification for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/API_Swagger_${FEATURE_NAME}.md"
acli rovodev run "Generate API Swagger/OpenAPI specification for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/API_Swagger_${FEATURE_NAME}.md"

echo "✅ API Swagger specification generation completed for: $FEATURE_NAME" 