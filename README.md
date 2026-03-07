# skill-creator-master

**Production-grade skill creation framework for AI agents.**

Build, validate, and publish professional skills for Claude Code, Cursor, Gemini CLI, and other AI agents. Battle-tested from real skill development on skills.sh.

---

## Install

```bash
npx skills add https://github.com/emrekent/skill-creator-master --skill skill-creator-master
```

## What It Does

When you say **"Create a new skill"** or **"Help me build a skill"**, this skill guides you through:

```
1. UNDERSTAND → Gather concrete usage examples
2. PLAN       → Identify scripts, references, assets needed
3. INIT       → Generate skill folder structure (automated)
4. BUILD      → Write SKILL.md + bundled resources
5. VALIDATE   → Run validation suite (automated)
6. PUBLISH    → Push to GitHub → verify discovery → first public install → live on skills.sh
```

---

## What's Inside

```
skill-creator-master/
├── SKILL.md                    Core skill guide (under 500 lines)
├── scripts/
│   ├── init_skill.sh           Generates new skill folders automatically
│   ├── validate_skill.sh       Validation before publishing
│   └── verify_publish.sh       Checks CLI discovery and skills.sh listing state
└── references/
    ├── structure-guide.md      Skill anatomy, YAML rules, file organization
    ├── lessons-learned.md      Real-world case study from translator-ai
    ├── anti-patterns.md        10 common mistakes and how to avoid them
    └── checklist.md            Pre-publish validation checklist
```

---

## Included Scripts

### Init Script — Generate a New Skill

```bash
bash scripts/init_skill.sh <skill-name> <output-directory>
```

Creates a complete skill folder with SKILL.md template, scripts/, references/, and assets/ directories.

### Validate Script — Check Before Publishing

```bash
bash scripts/validate_skill.sh <path/to/skill-folder>
```

Runs automated checks for:
- YAML frontmatter validation (name, description)
- SKILL.md line count (must be under 500)
- Placeholder detection
- Auxiliary file detection (warns about extra repo docs)
- Phantom reference detection
- Script executability
- Naming consistency

### Publish Verification Script — Check Real Listing Status

```bash
bash scripts/verify_publish.sh https://github.com/<username>/<repo> <skill-name>
```

Checks:
- The upstream `skills` CLI can discover the repo from GitHub
- The specific skill name is visible to the CLI
- The `skills.sh` search API contains the skill
- The `skills.sh/<owner>/<repo>/<skill>` page resolves

If the page is still missing, the script explains the usual reason: `skills.sh` listing is driven by successful public installs through the `skills` CLI, not by a GitHub push alone.

## How skills.sh Publishing Actually Works

1. Push the skill to a public GitHub repository.
2. Verify discoverability with `npx skills add <repo> --list`.
3. Perform at least one real public install with `npx skills add <repo> --skill <skill-name>`.
4. Re-check `https://skills.sh/<owner>/<repo>/<skill-name>`.

Important:
- `--list` verifies structure and frontmatter, but it does not publish.
- Local-path installs do not create `skills.sh` listings.
- `skills.sh` search and page generation are driven by anonymous install telemetry from the `skills` CLI, so indexing can lag after the first public install.

---

## Key Principles

- **Under 500 lines** — SKILL.md stays lean. Details go to references/
- **Description is the trigger** — Keywords in description determine when the skill activates
- **Progressive disclosure** — Metadata always loaded, body on trigger, references on demand
- **Working scripts only** — No placeholder code. Everything runs.
- **NOT clause required** — Tell the AI what NOT to use the skill for

---

## Battle-Tested

Built from real experience creating [translator-ai](https://github.com/emrekent/translator-ai) — a professional translation skill with 7 language pairs, 100+ examples, and 98%+ quality assurance. Every lesson learned is documented in `references/lessons-learned.md`.

---

## About the Creator

Built by **[Emre Kent](https://www.linkedin.com/in/emrekent)** — Systems architect & builder. Former math teacher turned automation designer.

I design growth engines, AI workflows, and automation systems. I build CRM architectures, AI agents, n8n automation systems, and personal operating systems that compound.

For discussions on AI agents, skills architecture, and automation systems — [connect on LinkedIn](https://www.linkedin.com/in/emrekent).

---

## Questions & Community

Have questions? Found a bug? Got a suggestion?

**Open a [Discussion](https://github.com/emrekent/skill-creator-master/discussions)** or [Issue](https://github.com/emrekent/skill-creator-master/issues).

---

## License

Open source. Free to use, adapt, and build on.
