# Pre-Publish Skill Checklist

Run through this checklist before publishing any skill. Every item marked CRITICAL must pass.

## 1. Frontmatter (CRITICAL)

- [ ] SKILL.md starts with `---` on line 1
- [ ] Frontmatter closes with `---`
- [ ] `name:` field present (lowercase, hyphens, digits only)
- [ ] `name:` is under 64 characters
- [ ] `name:` matches folder name
- [ ] `description:` field present
- [ ] `description:` is a single-line string
- [ ] `description:` includes what the skill does
- [ ] `description:` includes when to trigger (keywords)
- [ ] `description:` includes NOT clause (exclusions)
- [ ] No extra frontmatter fields (no version, author, license, compatibility)

## 2. SKILL.md Body (CRITICAL)

- [ ] Under 500 lines total
- [ ] Uses imperative/infinitive form ("To do X, execute Y")
- [ ] No TODO placeholders remaining
- [ ] Contains core workflow (numbered steps)
- [ ] References all bundled resource files
- [ ] Describes when to consult each reference file
- [ ] No "When to Use This Skill" section in body (this goes in description)

## 3. File Structure (CRITICAL)

- [ ] SKILL.md exists at root of skill folder
- [ ] Auxiliary files reviewed: README.md, INSTALLATION.md, CHANGELOG.md, LICENSE.md, TESTING.md, QUICK_REFERENCE.md
- [ ] No .DS_Store files
- [ ] Clean directory: only SKILL.md + scripts/ + references/ + assets/

## 4. Reference Integrity (CRITICAL)

- [ ] Every file referenced in SKILL.md actually exists
- [ ] No phantom references (mentioning files that don't exist)
- [ ] No orphan files (files that exist but aren't referenced anywhere)
- [ ] References are one level deep (no nested reference chains)
- [ ] Files over 100 lines have table of contents

## 5. Scripts (CRITICAL if scripts/ exists)

- [ ] Every script actually works (tested by running)
- [ ] No TODO or placeholder logic in scripts
- [ ] Scripts are executable (`chmod +x`)
- [ ] Scripts have clear CLI interface (args or stdin/stdout)
- [ ] Scripts output LLM-friendly messages (concise, not verbose)
- [ ] Scripts handle errors gracefully (useful error messages)
- [ ] Minimal dependencies (prefer stdlib)

## 6. Content Quality (IMPORTANT)

- [ ] Only includes knowledge AI doesn't already have
- [ ] Decision trees over verbose explanations
- [ ] Concise examples over long paragraphs
- [ ] No duplicate content between SKILL.md and references
- [ ] Anti-patterns documented (at least 1-2)
- [ ] Temporal knowledge dated where applicable

## 7. SEO / Discovery (IMPORTANT)

- [ ] Description includes relevant keywords users would search for
- [ ] Skill name is descriptive and unique
- [ ] Description is comprehensive but not bloated
- [ ] Keywords match actual use cases

## 8. GitHub + skills.sh Setup (IMPORTANT)

- [ ] Repository is public
- [ ] .gitignore excludes .DS_Store, node_modules, etc.
- [ ] Clean commit history
- [ ] Discussions enabled (optional but recommended)
- [ ] `npx skills add https://github.com/<user>/<repo> --list` finds the skill from GitHub
- [ ] `bash scripts/verify_publish.sh https://github.com/<user>/<repo> <skill-name>` passes with zero FAIL
- [ ] First public install completed if you expect a live `skills.sh` listing immediately
- [ ] Verified `https://skills.sh/<user>/<repo>/<skill-name>` after install telemetry has had time to index

## 9. Final Validation

Run the validation script:
```bash
bash scripts/validate_skill.sh <path/to/skill-folder>
```

- [ ] All PASS, zero FAIL
- [ ] Warnings reviewed and addressed (or justified)

## Quick Summary

| Category | Checks | Priority |
|----------|--------|----------|
| Frontmatter | 11 | CRITICAL |
| SKILL.md Body | 7 | CRITICAL |
| File Structure | 4 | CRITICAL |
| Reference Integrity | 5 | CRITICAL |
| Scripts | 7 | CRITICAL (if applicable) |
| Content Quality | 6 | IMPORTANT |
| SEO / Discovery | 4 | IMPORTANT |
| GitHub + skills.sh Setup | 8 | IMPORTANT |
| Final Validation | 2 | CRITICAL |
