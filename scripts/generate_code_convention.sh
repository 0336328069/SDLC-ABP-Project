#!/bin/bash

# Script: generate_code_convention.sh
# Purpose: Generate Code Convention document for a given feature
# Usage: ./generate_code_convention.sh <FeatureName>
# Example: ./generate_code_convention.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Code Convention document for feature: $FEATURE_NAME"

# Read the prompt template
PROMPT_TEMPLATE=$(cat prompts/code_convention.md)

# Replace placeholders with actual feature name
FULL_PROMPT=$(echo "$PROMPT_TEMPLATE" | sed "s/\[FeatureName\]/$FEATURE_NAME/g")

# Call AI with the full prompt
acli rovodev run "$FULL_PROMPT"

echo "✅ Code Convention document generation completed for: $FEATURE_NAME"  