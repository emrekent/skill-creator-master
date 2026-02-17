#!/bin/bash
# validate_skill.sh - Validate a skill before publishing
# Usage: bash validate_skill.sh <path/to/skill-folder>

set +e  # Don't exit on non-zero returns (grep returns 1 when no match)

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
WARNINGS=0

pass() { echo -e "${GREEN}  PASS${NC} $1"; ((PASSED++)); }
fail() { echo -e "${RED}  FAIL${NC} $1"; ((FAILED++)); }
warn() { echo -e "${YELLOW}  WARN${NC} $1"; ((WARNINGS++)); }

# Validate args
if [ $# -lt 1 ]; then
  echo -e "${RED}Usage: bash validate_skill.sh <path/to/skill-folder>${NC}"
  exit 1
fi

SKILL_DIR="$1"

if [ ! -d "$SKILL_DIR" ]; then
  echo -e "${RED}Error: Directory not found: $SKILL_DIR${NC}"
  exit 1
fi

SKILL_FILE="$SKILL_DIR/SKILL.md"
SKILL_NAME=$(basename "$SKILL_DIR")

echo ""
echo "Validating skill: $SKILL_NAME"
echo "Path: $SKILL_DIR"
echo ""

# ─────────────────────────────────────
# CHECK 1: SKILL.md exists
# ─────────────────────────────────────
echo "1. Core File Check"
if [ -f "$SKILL_FILE" ]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md not found"
  echo -e "${RED}Cannot continue without SKILL.md${NC}"
  exit 1
fi

# ─────────────────────────────────────
# CHECK 2: YAML Frontmatter
# ─────────────────────────────────────
echo "2. YAML Frontmatter"

# Check frontmatter markers
FRONTMATTER_START=$(head -1 "$SKILL_FILE")
if [ "$FRONTMATTER_START" = "---" ]; then
  pass "Frontmatter opening marker"
else
  fail "Missing frontmatter opening '---' on line 1"
fi

# Check closing marker
CLOSING_LINE=$(awk 'NR>1 && /^---$/{print NR; exit}' "$SKILL_FILE")
if [ -n "$CLOSING_LINE" ]; then
  pass "Frontmatter closing marker (line $CLOSING_LINE)"
else
  fail "Missing frontmatter closing '---'"
fi

# Check name field
if grep -q "^name:" "$SKILL_FILE"; then
  NAME_VALUE=$(grep "^name:" "$SKILL_FILE" | head -1 | sed 's/^name: *//')
  if echo "$NAME_VALUE" | grep -qE '^[a-z][a-z0-9-]*$'; then
    pass "name field: $NAME_VALUE"
  else
    fail "name must be lowercase letters, digits, hyphens: $NAME_VALUE"
  fi
else
  fail "Missing 'name:' field in frontmatter"
fi

# Check description field
if grep -q "^description:" "$SKILL_FILE"; then
  DESC_VALUE=$(grep "^description:" "$SKILL_FILE" | head -1 | sed 's/^description: *//')
  DESC_LEN=${#DESC_VALUE}
  if [ $DESC_LEN -gt 50 ]; then
    pass "description field ($DESC_LEN chars)"
  else
    fail "description too short ($DESC_LEN chars) - needs to be comprehensive"
  fi

  # Check for NOT clause
  if echo "$DESC_VALUE" | grep -qi "NOT for\|NOT applicable\|not for"; then
    pass "description includes NOT clause"
  else
    warn "description missing NOT clause (recommended for preventing false triggers)"
  fi
else
  fail "Missing 'description:' field in frontmatter"
fi

# Check for forbidden frontmatter fields
FORBIDDEN_FIELDS=("version:" "author:" "license:" "compatibility:" "language_pairs:" "allowed-tools:")
for field in "${FORBIDDEN_FIELDS[@]}"; do
  if awk "NR>1 && NR<$CLOSING_LINE" "$SKILL_FILE" 2>/dev/null | grep -q "^$field"; then
    warn "Unnecessary frontmatter field: $field (only name and description are read by AI agents)"
  fi
done

# ─────────────────────────────────────
# CHECK 3: Line Count
# ─────────────────────────────────────
echo "3. Size Check"
LINE_COUNT=$(wc -l < "$SKILL_FILE" | tr -d ' ')
if [ "$LINE_COUNT" -le 500 ]; then
  pass "SKILL.md is $LINE_COUNT lines (max 500)"
else
  fail "SKILL.md is $LINE_COUNT lines (exceeds 500 line limit)"
fi

# ─────────────────────────────────────
# CHECK 4: TODO Check
# ─────────────────────────────────────
echo "4. TODO Placeholders"
TODO_COUNT=$(grep -ci "TODO" "$SKILL_FILE" 2>/dev/null)
if [ -z "$TODO_COUNT" ]; then TODO_COUNT=0; fi
if [ "$TODO_COUNT" -eq 0 ]; then
  pass "No TODO placeholders remaining"
else
  fail "$TODO_COUNT TODO placeholders found - replace before publishing"
fi

# ─────────────────────────────────────
# CHECK 5: Forbidden Files
# ─────────────────────────────────────
echo "5. Forbidden Files"
FORBIDDEN_FILES=("README.md" "INSTALLATION.md" "CHANGELOG.md" "QUICK_REFERENCE.md" "TESTING.md" "LICENSE.md" "COMPREHENSIVE_TEST_SUITE.md")
FOUND_FORBIDDEN=0
for file in "${FORBIDDEN_FILES[@]}"; do
  if [ -f "$SKILL_DIR/$file" ]; then
    fail "Forbidden file found: $file (skills should only contain SKILL.md + resources)"
    ((FOUND_FORBIDDEN++))
  fi
done
if [ $FOUND_FORBIDDEN -eq 0 ]; then
  pass "No forbidden auxiliary files"
fi

# ─────────────────────────────────────
# CHECK 6: Phantom References
# ─────────────────────────────────────
echo "6. Reference Integrity"
PHANTOM=0
# Check for referenced files in SKILL.md
while IFS= read -r ref; do
  REF_PATH="$SKILL_DIR/$ref"
  if [ ! -f "$REF_PATH" ] && [ ! -d "$REF_PATH" ]; then
    fail "Phantom reference: $ref (referenced in SKILL.md but doesn't exist)"
    ((PHANTOM++))
  fi
done < <(grep -oE '(scripts|references|assets)/[a-zA-Z0-9._-]+\.[a-zA-Z0-9]+' "$SKILL_FILE" 2>/dev/null | sort -u)

if [ $PHANTOM -eq 0 ]; then
  pass "All referenced files exist"
fi

# ─────────────────────────────────────
# CHECK 7: Script Executability
# ─────────────────────────────────────
echo "7. Script Check"
if [ -d "$SKILL_DIR/scripts" ]; then
  SCRIPT_COUNT=$(find "$SKILL_DIR/scripts" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.cjs" \) | wc -l | tr -d ' ')
  if [ "$SCRIPT_COUNT" -gt 0 ]; then
    while IFS= read -r script; do
      if [ -x "$script" ]; then
        pass "$(basename "$script") is executable"
      else
        warn "$(basename "$script") is not executable (run: chmod +x)"
      fi
    done < <(find "$SKILL_DIR/scripts" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.cjs" \))
  else
    pass "No scripts to check (scripts/ empty or no recognized extensions)"
  fi
else
  pass "No scripts/ directory (optional)"
fi

# ─────────────────────────────────────
# CHECK 8: Skill Name Matches Folder
# ─────────────────────────────────────
echo "8. Naming Consistency"
if [ -n "$NAME_VALUE" ] && [ "$NAME_VALUE" = "$SKILL_NAME" ]; then
  pass "Skill name matches folder name: $SKILL_NAME"
else
  warn "Skill name ($NAME_VALUE) doesn't match folder name ($SKILL_NAME)"
fi

# ─────────────────────────────────────
# SUMMARY
# ─────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════"
echo "VALIDATION SUMMARY: $SKILL_NAME"
echo "═══════════════════════════════════════════"
TOTAL=$((PASSED + FAILED))
echo -e "${GREEN}  PASSED:   $PASSED${NC}"
echo -e "${RED}  FAILED:   $FAILED${NC}"
echo -e "${YELLOW}  WARNINGS: $WARNINGS${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}RESULT: READY TO PUBLISH${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Push to GitHub"
  echo "  2. Verify at: https://skills.sh/<username>/<repo>/$SKILL_NAME"
  echo "  3. Users install: npx skills add https://github.com/<username>/<repo> --skill $SKILL_NAME"
  exit 0
else
  echo -e "${RED}RESULT: FIX $FAILED ERROR(S) BEFORE PUBLISHING${NC}"
  exit 1
fi
