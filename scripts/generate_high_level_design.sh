#!/bin/bash

# Script: generate_high_level_design.sh
# Purpose: Generate High Level Design Document for a given feature
# Usage: ./generate_high_level_design.sh <FeatureName>
# Example: ./generate_high_level_design.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating High Level Design for feature: $FEATURE_NAME"

# Call AI with simple prompt - AI will automatically read all reference files
# gemini -y -m gemini-2.5-flash -p "Generate High Level Design document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/HighLevelDesign_${FEATURE_NAME}.md"
acli rovodev run "Generate High Level Design document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/HighLevelDesign_${FEATURE_NAME}.md"

echo "✅ High Level Design generation completed for: $FEATURE_NAME" 