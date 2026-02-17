#!/bin/bash
# init_skill.sh - Generate a new skill folder structure
# Usage: bash init_skill.sh <skill-name> <output-directory>

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Validate args
if [ $# -lt 2 ]; then
  echo -e "${RED}Usage: bash init_skill.sh <skill-name> <output-directory>${NC}"
  echo "Example: bash init_skill.sh my-skill /path/to/output"
  exit 1
fi

SKILL_NAME="$1"
OUTPUT_DIR="$2"
SKILL_DIR="$OUTPUT_DIR/$SKILL_NAME"

# Validate skill name (lowercase, hyphens, digits only)
if ! echo "$SKILL_NAME" | grep -qE '^[a-z][a-z0-9-]*$'; then
  echo -e "${RED}Error: Skill name must be lowercase letters, digits, and hyphens only.${NC}"
  echo "Example: my-skill-name"
  exit 1
fi

# Check name length
if [ ${#SKILL_NAME} -gt 64 ]; then
  echo -e "${RED}Error: Skill name must be under 64 characters.${NC}"
  exit 1
fi

# Check if directory exists
if [ -d "$SKILL_DIR" ]; then
  echo -e "${RED}Error: Directory already exists: $SKILL_DIR${NC}"
  exit 1
fi

echo ""
echo "Creating skill: $SKILL_NAME"
echo "Location: $SKILL_DIR"
echo ""

# Create directories
mkdir -p "$SKILL_DIR/scripts"
mkdir -p "$SKILL_DIR/references"
mkdir -p "$SKILL_DIR/assets"

# Create SKILL.md with template
cat > "$SKILL_DIR/SKILL.md" << 'SKILLEOF'
---
name: TODO_SKILL_NAME
description: TODO - Write a clear description. Include what the skill does, when to trigger it, specific keywords, and a NOT clause for exclusions. This is the primary trigger mechanism. Example - Professional X for Y and Z. Use when doing A, B, C. Handles D, E, F content types. NOT for G, H, I.
---

# TODO_SKILL_TITLE

TODO - One sentence describing what this skill does.

## Core Workflow

```
1. STEP ONE   → TODO describe
2. STEP TWO   → TODO describe
3. STEP THREE → TODO describe
```

## Key Rules

TODO - List non-obvious domain knowledge the AI agent needs.

1. **Rule 1** - TODO
2. **Rule 2** - TODO
3. **Rule 3** - TODO

## Anti-Patterns

TODO - What mistakes should the AI agent avoid?

1. **Don't do X** - TODO why
2. **Don't do Y** - TODO why

## References

- `references/` - TODO list reference files and when to consult them
SKILLEOF

# Replace skill name in template
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/TODO_SKILL_NAME/$SKILL_NAME/g" "$SKILL_DIR/SKILL.md"
else
  sed -i "s/TODO_SKILL_NAME/$SKILL_NAME/g" "$SKILL_DIR/SKILL.md"
fi

# Create example reference file
cat > "$SKILL_DIR/references/example-reference.md" << 'EOF'
# Example Reference

TODO - Replace this with actual reference content.

This file is loaded into context only when the AI agent needs it.
Keep detailed domain knowledge, schemas, and examples here.

Delete this file if not needed.
EOF

# Create example script
cat > "$SKILL_DIR/scripts/example-script.sh" << 'EOF'
#!/bin/bash
# Example script - TODO replace or delete
# Scripts should: work without modification, have minimal dependencies,
# output LLM-friendly messages, handle errors gracefully.

echo "Example script executed successfully."
echo "Replace this with your actual script logic."
EOF
chmod +x "$SKILL_DIR/scripts/example-script.sh"

# Create example asset
cat > "$SKILL_DIR/assets/example-asset.txt" << 'EOF'
Example asset file - TODO replace or delete.
Assets are files used in output (templates, images, boilerplate).
They are NOT loaded into context.
EOF

# Summary
echo -e "${GREEN}Skill initialized successfully!${NC}"
echo ""
echo "Structure:"
echo "  $SKILL_DIR/"
echo "  ├── SKILL.md              (edit this first)"
echo "  ├── scripts/"
echo "  │   └── example-script.sh (replace or delete)"
echo "  ├── references/"
echo "  │   └── example-reference.md (replace or delete)"
echo "  └── assets/"
echo "      └── example-asset.txt (replace or delete)"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Edit SKILL.md - Replace all TODO placeholders"
echo "  2. Add your scripts, references, and assets"
echo "  3. Delete example files you don't need"
echo "  4. Run validate_skill.sh before publishing"
