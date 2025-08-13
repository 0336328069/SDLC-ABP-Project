#!/bin/bash

# Script: generate_frontend_prompt.sh
# Purpose: Generate Frontend implementation prompt for a given feature
# Usage: ./generate_frontend_prompt.sh <FeatureName>
# Example: ./generate_frontend_prompt.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Frontend prompt for feature: $FEATURE_NAME"

# Call Claude Code to create specific prompt using META template
# Claude will automatically read all reference files and use the META prompt template
claude "Use META_PROMPT_Frontend_Generator.md to create a Frontend implementation prompt for feature $FEATURE_NAME. Read all required input files: Document_Backend_API_${FEATURE_NAME}.md, ImplementPlan_${FEATURE_NAME}.md, and PRD_${FEATURE_NAME}.md from docs/BA and docs/DEV directories. Auto-detect project configuration from codebase. Generate FRONTEND_${FEATURE_NAME}_Prompt.md file with complete implementation instructions."

echo "✅ Frontend prompt generation completed for: $FEATURE_NAME"