# Skill Structure Guide

## Table of Contents
- Skill Anatomy
- YAML Frontmatter Rules
- SKILL.md Body Guidelines
- Scripts Best Practices
- References Best Practices
- Assets Best Practices
- Progressive Disclosure Patterns
- File Organization

## Skill Anatomy

Every skill consists of:

```
skill-name/
├── SKILL.md              (required - under 500 lines)
├── scripts/              (optional - executable code)
├── references/           (optional - domain knowledge)
└── assets/               (optional - templates, images)
```

No other top-level files. No README. No LICENSE. No CHANGELOG.

## YAML Frontmatter Rules

### Required Fields

```yaml
---
name: skill-name
description: What it does. When to use. Keywords. NOT for exclusions.
---
```

### What Each Field Does

**name:**
- Lowercase letters, digits, hyphens only
- Under 64 characters
- Must match folder name
- Verb-led phrases preferred (e.g., `translate-docs`, `generate-charts`)

**description:**
- Single-line string
- PRIMARY trigger mechanism (the AI reads this to decide when to activate)
- Must include: what the skill does + when to trigger + keywords + NOT clause
- All "when to use" info goes here, NOT in the body
- Body is only loaded AFTER triggering, so trigger info in body is wasted

### Fields NOT to Include

Do not add any of these to frontmatter:
- `version:` - not read by AI agents
- `author:` - not read by AI agents
- `license:` - not read by AI agents
- `compatibility:` - rarely needed
- `language_pairs:` - put in description instead
- `allowed-tools:` - only if specifically needed for tool permissions

## SKILL.md Body Guidelines

### Line Limit: 500

If approaching 500 lines, move content to `references/`.

### Writing Style

- Imperative/infinitive form: "To do X, execute Y"
- NOT: "You should do X" or "If you need to do Z"
- Concise examples over verbose explanations
- Decision trees over templates
- Only include what AI doesn't already know

### Recommended Structure

```markdown
# Skill Name
[One sentence purpose]

## Core Workflow
[Numbered steps - the main process]

## Key Rules
[Non-obvious domain knowledge, 3-6 rules]

## Anti-Patterns
[Common mistakes, 3-5 items]

## References
[List of reference files with when to consult each]
```

### What Goes in SKILL.md vs References

| Content Type | Where | Why |
|-------------|-------|-----|
| Core workflow steps | SKILL.md | Always needed |
| Decision logic | SKILL.md | Guides execution |
| Detailed examples | references/ | Loaded on demand |
| Domain schemas | references/ | Loaded on demand |
| Anti-pattern details | references/ | Loaded on demand |
| Templates | assets/ | Used in output |

## Scripts Best Practices

### When to Include Scripts

- Same code rewritten repeatedly
- Deterministic reliability needed
- Validation/checking logic
- Init/setup automation

### Script Requirements

1. **Must work.** No TODO stubs. No placeholder logic.
2. **Minimal dependencies.** Prefer stdlib (bash, python stdlib).
3. **Clear CLI interface.** Arguments or stdin/stdout.
4. **LLM-friendly output.** Concise success/failure messages.
5. **Error handling.** Graceful failures with useful messages.
6. **Executable.** `chmod +x` on all scripts.

### Script Output Guidelines

```bash
# Good - concise, actionable
echo "PASS: SKILL.md is 342 lines (under 500 limit)"
echo "FAIL: Missing description field in frontmatter"

# Bad - verbose, hard to parse
echo "The validation process has completed checking your SKILL.md file
      and determined that while the line count of 342 is acceptable..."
```

## References Best Practices

### When to Include References

- Domain knowledge AI doesn't have
- Detailed examples (more than 2-3)
- Schemas, API docs, specifications
- Company-specific policies or conventions

### Reference File Rules

1. **No duplication.** Content lives in SKILL.md OR references, not both.
2. **Table of contents.** Files over 100 lines need one at top.
3. **One level deep.** All references link directly from SKILL.md.
4. **Clear naming.** `examples.md` not `ex.md`. `anti-patterns.md` not `ap.md`.
5. **Describe when to read.** In SKILL.md: "See references/X.md for Y scenarios."

## Assets Best Practices

### When to Include Assets

- Templates used in output (HTML, React, etc.)
- Images (logos, icons)
- Boilerplate code to copy
- Fonts, sample documents

### Key Rule

Assets are NOT loaded into context. They are used in output.

## Progressive Disclosure Patterns

### Pattern 1: High-Level Guide with References

```markdown
# Main Skill

## Quick Start
[Core workflow - always loaded]

## Advanced
- See `references/advanced.md` for complex scenarios
- See `references/examples.md` for real-world patterns
```

### Pattern 2: Domain-Specific Organization

```
my-skill/
├── SKILL.md (routing + core logic)
└── references/
    ├── domain-a.md (loaded for domain A tasks)
    ├── domain-b.md (loaded for domain B tasks)
    └── domain-c.md (loaded for domain C tasks)
```

### Pattern 3: Conditional Details

```markdown
## Basic Usage
[Always shown]

## Advanced Usage
**For tracked changes**: See `references/tracking.md`
**For batch operations**: See `references/batch.md`
```

## File Organization

### Naming Conventions

- Skill folder: `lowercase-with-hyphens`
- Scripts: `lowercase-with-hyphens.sh` or `.py`
- References: `lowercase-with-hyphens.md`
- Assets: descriptive names matching their purpose

### What NOT to Include

These files are forbidden in skills:
- `README.md`
- `INSTALLATION.md`
- `INSTALLATION_GUIDE.md`
- `CHANGELOG.md`
- `QUICK_REFERENCE.md`
- `TESTING.md`
- `LICENSE.md`
- `COMPREHENSIVE_TEST_SUITE.md`
- `.DS_Store`

Skills contain only what the AI agent needs to do the job.
