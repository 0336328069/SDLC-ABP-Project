#!/bin/bash

# Script: generate_low_level_design.sh
# Purpose: Generate Low Level Design Document for a given feature
# Usage: ./generate_low_level_design.sh <FeatureName>
# Example: ./generate_low_level_design.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Low Level Design for feature: $FEATURE_NAME"

# Call AI with simple prompt - AI will automatically read all reference files
# gemini -y -m gemini-2.5-flash -p "Generate Low Level Design document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/LowLevelDesign_${FEATURE_NAME}.md"
acli rovodev run "Generate Low Level Design document for feature $FEATURE_NAME. Read all reference files in docs/BA and docs/DEV directories and create docs/DEV/LowLevelDesign_${FEATURE_NAME}.md"

echo "✅ Low Level Design generation completed for: $FEATURE_NAME" 