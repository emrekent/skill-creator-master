#!/bin/bash
# verify_publish.sh - Verify GitHub discovery and skills.sh listing state
# Usage: bash verify_publish.sh <github-source> <skill-name>

set -u

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

usage() {
  echo "Usage: bash scripts/verify_publish.sh <github-source> <skill-name>"
  echo "Example: bash scripts/verify_publish.sh https://github.com/emrekent/translator-ai translator-ai"
}

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

SOURCE="$1"
SKILL_NAME="$2"
OWNER_REPO=""

if [[ "$SOURCE" =~ ^https://github\.com/([^/]+)/([^/]+) ]]; then
  OWNER_REPO="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  OWNER_REPO="${OWNER_REPO%.git}"
elif [[ "$SOURCE" =~ ^([^/]+)/([^/@]+)(@.+)?$ ]]; then
  OWNER_REPO="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
fi

echo ""
echo "Verifying publish state"
echo "Source: $SOURCE"
echo "Skill:  $SKILL_NAME"
echo ""

echo "1. CLI Discovery"
if command -v npx >/dev/null 2>&1; then
  pass "npx is available"
else
  fail "npx is required to verify GitHub discovery"
fi

LIST_OUTPUT="$(npx -y skills@1.4.4 add "$SOURCE" --list 2>&1)"
LIST_STATUS=$?
if [ $LIST_STATUS -eq 0 ]; then
  pass "skills CLI could read the repository"
else
  fail "skills CLI could not read the repository"
fi

if echo "$LIST_OUTPUT" | grep -Fq "$SKILL_NAME"; then
  pass "skills CLI discovered $SKILL_NAME"
else
  fail "skills CLI did not discover $SKILL_NAME"
fi

if [ -z "$OWNER_REPO" ]; then
  warn "Could not derive owner/repo from source; skipping skills.sh URL checks"
else
  SKILL_URL="https://skills.sh/$OWNER_REPO/$SKILL_NAME"
  SEARCH_URL="https://skills.sh/api/search?q=$SKILL_NAME&limit=20"

  echo "2. skills.sh Status"

  PAGE_STATUS="$(curl -I -L -s -o /dev/null -w "%{http_code}" "$SKILL_URL")"
  if [ "$PAGE_STATUS" = "200" ]; then
    pass "skills.sh page resolves: $SKILL_URL"
  else
    warn "skills.sh page returns HTTP $PAGE_STATUS: $SKILL_URL"
  fi

  SEARCH_OUTPUT="$(curl -L -s "$SEARCH_URL")"
  if echo "$SEARCH_OUTPUT" | grep -Fq "\"id\":\"$OWNER_REPO/$SKILL_NAME\""; then
    pass "skills.sh search index contains $OWNER_REPO/$SKILL_NAME"
  else
    warn "skills.sh search index does not yet contain $OWNER_REPO/$SKILL_NAME"
  fi

  if [ "$PAGE_STATUS" != "200" ] || ! echo "$SEARCH_OUTPUT" | grep -Fq "\"id\":\"$OWNER_REPO/$SKILL_NAME\""; then
    echo ""
    echo "Note:"
    echo "  skills.sh listings come from successful public installs tracked by the skills CLI."
    echo "  A GitHub push or '--list' check alone does not create a listing."
    echo "  Run a real install from the public GitHub source, then re-check after indexing catches up."
  fi
fi

echo ""
echo "Summary"
echo -e "${GREEN}  PASSED:   $PASSED${NC}"
echo -e "${RED}  FAILED:   $FAILED${NC}"
echo -e "${YELLOW}  WARNINGS: $WARNINGS${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
  exit 0
else
  exit 1
fi
