#!/bin/bash

# Script: generate_implement_plan.sh
# Purpose: Generate Implementation Plan for a given feature
# Usage: ./generate_implement_plan.sh <FeatureName>
# Example: ./generate_implement_plan.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Implementation Plan for feature: $FEATURE_NAME"

# Call AI with simple prompt - AI will automatically read all reference files
# gemini -y -m gemini-2.5-flash -p "Generate Implementation Plan document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/ImplementPlan_${FEATURE_NAME}.md"
acli rovodev run "Generate Implementation Plan document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/ImplementPlan_${FEATURE_NAME}.md"

echo "✅ Implementation Plan generation completed for: $FEATURE_NAME"
