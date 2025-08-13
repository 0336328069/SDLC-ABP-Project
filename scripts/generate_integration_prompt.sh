#!/bin/bash

# Script: generate_integration_prompt.sh
# Purpose: Generate Integration implementation prompt for a given feature
# Usage: ./generate_integration_prompt.sh <FeatureName>
# Example: ./generate_integration_prompt.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Integration prompt for feature: $FEATURE_NAME"

# Call Claude Code to create specific prompt using META template
# Claude will automatically read all reference files and use the META prompt template
claude "Use META_PROMPT_Integration_Generator.md to create an Integration implementation prompt for feature $FEATURE_NAME. Read all required input files: ImplementPlan_${FEATURE_NAME}.md, PRD_${FEATURE_NAME}.md, Document_Domain_Model_${FEATURE_NAME}.md, Document_Domain_Service_${FEATURE_NAME}.md, and Document_Application_Layer_${FEATURE_NAME}.md from docs/BA and docs/DEV directories. Auto-detect project configuration from codebase. Generate INTEGRATION_${FEATURE_NAME}_Prompt.md file with complete implementation instructions."

echo "✅ Integration prompt generation completed for: $FEATURE_NAME"