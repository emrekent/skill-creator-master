---
name: skill-creator-master
description: Master-level skill creation guide for building production-grade AI agent skills. Use when creating new skills, auditing existing skills, validating skill structure, or publishing to skills.sh. Covers SKILL.md writing, YAML frontmatter, progressive disclosure, bundled resources (scripts/references/assets), quality assurance, and SEO optimization. Includes init and validation scripts. Battle-tested from real skill development. NOT for general coding, not for using existing skills, not for non-skill AI tasks.
---

# Skill Creator Master

Create production-grade AI agent skills. Battle-tested framework with init scripts, validation, and real-world patterns.

## 6-Step Skill Creation Process

```
1. UNDERSTAND → Gather concrete usage examples (3-5 minimum)
2. PLAN       → Identify scripts, references, assets needed
3. INIT       → Run scripts/init_skill.sh to generate structure
4. BUILD      → Write SKILL.md + bundled resources
5. VALIDATE   → Run scripts/validate_skill.sh to check quality
6. PUBLISH    → Push to GitHub, verify on skills.sh
```

## Step 1: Understand with Concrete Examples

Before writing anything, gather 3-5 concrete examples of how the skill will be used.

Ask:
- "What should this skill do? Give me 2-3 real examples."
- "What would a user say to trigger this skill?"
- "What should this skill NOT do?"

Conclude when usage patterns are clear. Do not over-interview.

## Step 2: Plan Reusable Contents

For each example, analyze:
1. How to execute from scratch
2. What would be helpful for repeated execution

Map each need to the right resource type:

| Need | Resource Type | Example |
|------|--------------|---------|
| Repeatable code | `scripts/` | rotate_pdf.sh, validate.sh |
| Domain knowledge | `references/` | schema.md, api-docs.md |
| Templates/boilerplate | `assets/` | template.html, logo.png |
| Workflow guidance | SKILL.md body | Decision trees, steps |

## Step 3: Initialize the Skill

Run the init script to generate a complete skill folder:

```bash
bash scripts/init_skill.sh <skill-name> <output-directory>
```

This creates:
- SKILL.md with YAML template and placeholder markers
- `scripts/`, `references/`, `assets/` directories
- Example files to customize or delete

Delete any example files not needed for the skill.

## Step 4: Build the Skill

### 4A: YAML Frontmatter (Critical)

Only two fields allowed:

```yaml
---
name: your-skill-name
description: [What it does] [When to use] [Trigger keywords]. NOT for [exclusions].
---
```

**Rules:**
- `name`: lowercase-with-hyphens, under 64 characters
- `description`: Single-line string. This is the PRIMARY trigger mechanism.
  - Include what the skill does AND when to trigger
  - Include specific keywords users would say
  - Include NOT clause for exclusions
  - All "when to use" info goes HERE, not in body
- Do NOT add other frontmatter fields (no license, version, author, compatibility)

**Good description example:**
```
description: Professional translation for English-Turkish, Spanish, French, German, Portuguese, Italian, Russian. Use when translating text, documents, or content between languages. Handles technical, marketing, business, casual, and formal content. NOT for language learning, grammar checking, or spell checking.
```

### 4B: SKILL.md Body

**Constraint: Under 500 lines.** Move details to `references/`.

**Writing rules:**
- Use imperative/infinitive form ("To do X, execute Y")
- Concise examples over verbose explanations
- Decision trees over templates
- Only include what the AI agent doesn't already know

**Body structure:**
```markdown
# Skill Name
[One sentence purpose]

## Core Workflow
[Numbered steps with decision points]

## Key Rules
[Non-obvious domain knowledge]

## Anti-Patterns
[Common mistakes to avoid]

## References
- [reference files] - [When to consult this file]
```

### 4C: Bundled Resources

**Scripts (`scripts/`):**
- Must actually work (no placeholder stubs)
- Minimal dependencies (prefer stdlib)
- Clear CLI interface (args or stdin/stdout)
- LLM-friendly output (concise success/failure messages)

**References (`references/`):**
- Domain knowledge, schemas, detailed guides
- Loaded only when needed (progressive disclosure)
- Files over 100 lines should have table of contents
- No duplication with SKILL.md content

**Assets (`assets/`):**
- Templates, images, boilerplate used in output
- Not loaded into context, used in final output

### 4D: What NOT to Include

Do NOT create these files:
- README.md
- INSTALLATION.md
- CHANGELOG.md
- QUICK_REFERENCE.md
- TESTING.md
- LICENSE.md

Skills contain only what the AI agent needs to do the job. No auxiliary documentation.

## Step 5: Validate

Run the validation script:

```bash
bash scripts/validate_skill.sh <path/to/skill-folder>
```

Checks:
- YAML frontmatter has name and description
- SKILL.md under 500 lines
- No unfinished placeholders remaining
- No forbidden files (README, CHANGELOG, etc.)
- All referenced files exist (no phantom references)
- Description includes trigger keywords
- Skill name matches folder name

Fix all errors before publishing.

## Step 6: Publish to skills.sh

1. Push skill folder to a GitHub repository
2. Verify at: `https://skills.sh/<username>/<repo>/<skill-name>`
3. skills.sh auto-indexes from your GitHub repo
4. Users install with: `npx skills add https://github.com/<username>/<repo> --skill <skill-name>`

**SEO tips for skills.sh discovery:**
- Description keywords determine search ranking
- Include specific language/tool names in description
- GitHub stars improve ranking
- Weekly installs improve ranking
- Skill name should be descriptive and unique

## Progressive Disclosure Design

Skills use three-level loading:

| Level | Content | Size | When Loaded |
|-------|---------|------|-------------|
| 1. Metadata | name + description | ~100 tokens | Always in context |
| 2. SKILL.md body | Core instructions | <5K tokens | When skill triggers |
| 3. Resources | Scripts, references | Unlimited | As agent needs them |

**Pattern: High-level guide with references**
```markdown
## Core Workflow
[Essential steps in SKILL.md]

## Deep Dives
- [your-reference-file].md - For complex scenarios
- [your-examples-file].md - Real-world patterns
```

**Pattern: Domain-specific organization**
```
my-skill/
├── SKILL.md (workflow + selection logic)
└── references/
    ├── domain-a.md (loaded only for domain A)
    ├── domain-b.md (loaded only for domain B)
    └── domain-c.md (loaded only for domain C)
```

**Rules:**
- Keep references one level deep from SKILL.md
- Files over 100 lines need table of contents
- Never duplicate content between SKILL.md and references

## Degrees of Freedom

Match specificity to task fragility:

- **High freedom** (text instructions): Multiple valid approaches, context-dependent
- **Medium freedom** (pseudocode/scripts with params): Preferred pattern exists, some variation OK
- **Low freedom** (exact scripts, few params): Fragile operations, consistency critical

## Common Anti-Patterns

For detailed anti-patterns with examples, see `references/anti-patterns.md`.

Quick reference:
1. **Documentation Dump** - 50-page tutorial in SKILL.md. Keep under 500 lines.
2. **Missing NOT Clause** - Description without exclusions causes false triggers.
3. **Phantom Tools** - Referencing scripts that don't exist.
4. **Template Soup** - Scripts with placeholder comments instead of working code.
5. **Everything Skill** - One skill for all operations. Split by expertise type.
6. **Auxiliary File Bloat** - README, CHANGELOG, LICENSE in skill folder.

## Quality Checklist

For full pre-publish checklist, see `references/checklist.md`.

Essential checks:
- [ ] SKILL.md exists and is under 500 lines
- [ ] Frontmatter has name and description only
- [ ] Description includes trigger keywords and NOT clause
- [ ] All referenced scripts/files exist and work
- [ ] No unfinished placeholders remaining
- [ ] No forbidden auxiliary files
- [ ] Tested with real usage examples

## Real-World Lessons

For battle-tested insights from building production skills, see `references/lessons-learned.md`.

Key takeaways:
- Description is your SEO. Keywords there determine discoverability.
- GitHub stars and install count drive skills.sh ranking.
- User feedback in first week shapes skill quality permanently.
- Start lean, iterate based on real usage. Don't over-build.

## Available Scripts

- `scripts/init_skill.sh <name> <path>` - Generate new skill folder structure
- `scripts/validate_skill.sh <path>` - Validate skill before publishing
