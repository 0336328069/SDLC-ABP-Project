#!/bin/bash

# Script: generate_domain_service_prompt.sh
# Purpose: Generate Domain Service implementation prompt for a given feature
# Usage: ./generate_domain_service_prompt.sh <FeatureName>
# Example: ./generate_domain_service_prompt.sh Authentication

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Please provide the feature name. Usage: $0 <FeatureName>"
  exit 1
fi

echo "🚀 Generating Domain Service prompt for feature: $FEATURE_NAME"

# Call Claude Code to create specific prompt using META template
# Claude will automatically read all reference files and use the META prompt template
claude "Use META_PROMPT_Domain_Service_Generator.md to create a Domain Service implementation prompt for feature $FEATURE_NAME. Read all required input files: BusinessLogic_${FEATURE_NAME}.md, Document_Domain_Model_${FEATURE_NAME}.md, ImplementPlan_${FEATURE_NAME}.md, and PRD_${FEATURE_NAME}.md from docs/BA and docs/DEV directories. Auto-detect project configuration from codebase. Generate DOMAIN_SERVICE_${FEATURE_NAME}_Prompt.md file with complete implementation instructions."

echo "✅ Domain Service prompt generation completed for: $FEATURE_NAME"