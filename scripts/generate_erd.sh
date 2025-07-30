#!/bin/bash

# Script: generate_erd.sh
# Purpose: Generate Entity Relationship Diagram for a given feature
# Usage: ./generate_erd.sh <FeatureName>
# Example: ./generate_erd.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating ERD for feature: $FEATURE_NAME"

# Call AI with simple prompt - AI will automatically read all reference files
# gemini -y -m gemini-2.5-flash -p "Generate Entity Relationship Diagram document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/ERD_${FEATURE_NAME}.md"
acli rovodev run "Generate Entity Relationship Diagram document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/ERD_${FEATURE_NAME}.md"

echo "✅ ERD generation completed for: $FEATURE_NAME" 