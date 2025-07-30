#!/bin/bash

# Script: generate_technical_architect.sh
# Purpose: Generate Technical Architecture document for a given feature
# Usage: ./generate_technical_architect.sh <FeatureName>
# Example: ./generate_technical_architect.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Technical Architecture document for feature: $FEATURE_NAME"

# Call AI with simple prompt - AI will automatically read all reference files
# gemini -y -m gemini-2.5-flash -p "Generate Technical Architecture document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/TechnicalArchitecture_${FEATURE_NAME}.md"
acli rovodev run "Generate Technical Architecture document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/TechnicalArchitecture_${FEATURE_NAME}.md"

echo "✅ Technical Architecture document generation completed for: $FEATURE_NAME" 