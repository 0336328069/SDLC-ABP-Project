#!/bin/bash

# Script: generate_backend_api_prompt.sh
# Purpose: Generate Backend API implementation prompt for a given feature
# Usage: ./generate_backend_api_prompt.sh <FeatureName>
# Example: ./generate_backend_api_prompt.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Backend API prompt for feature: $FEATURE_NAME"

# Call Claude Code to create specific prompt using META template
# Claude will automatically read all reference files and use the META prompt template
claude "Use META_PROMPT_Backend_API_Generator.md to create a Backend API implementation prompt for feature $FEATURE_NAME. Read all required input files: Document_Application_Layer_${FEATURE_NAME}.md, ImplementPlan_${FEATURE_NAME}.md, and PRD_${FEATURE_NAME}.md from docs/BA and docs/DEV directories. Auto-detect project configuration from codebase. Generate BACKEND_API_${FEATURE_NAME}_Prompt.md file with complete implementation instructions."

echo "✅ Backend API prompt generation completed for: $FEATURE_NAME"