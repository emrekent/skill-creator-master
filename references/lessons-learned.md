# Lessons Learned from Building Production Skills

## Table of Contents
- Case Study: translator-ai (Real Production Skill)
- Description is Everything
- Progressive Disclosure in Practice
- User Feedback Loops
- SEO and Discovery on skills.sh
- GitHub as Infrastructure
- Quality Over Quantity
- What We'd Do Differently

## Case Study: translator-ai

A professional translation skill built for skills.sh. English-Turkish primary, 7 language pairs total. 100 professional examples. Went from zero to production in one intensive session.

### What Worked

1. **Starting with the primary use case.** English-Turkish first, then expanded. Don't try to build everything at once.

2. **User feedback on every example.** 100 examples reviewed one-by-one by a native speaker. This is what separates "decent" from "professional."

3. **Reference files for detailed content.** SKILL.md stayed focused on workflow. Examples, rules, grammar comparisons went to `references/`.

4. **Automated validation before publishing.** Caught encoding issues, missing files, and structural problems before they reached users.

5. **GitHub Discussions for community.** Zero-friction feedback channel. No account noise.

### What Didn't Work

1. **Too many auxiliary files initially.** README.md, INSTALLATION.md, TESTING.md, LICENSE.md, COMPREHENSIVE_TEST_SUITE.md. These are useful for humans but waste tokens for AI agents. Per Anthropic's official guidance: skills should only contain SKILL.md + resources.

2. **Description wasn't SEO-optimized initially.** Generic description meant poor discoverability. Updated with specific keywords (English-Turkish, Spanish, French, etc.) and immediately improved.

3. **Frontmatter had too many fields.** version, author, license, language_pairs, compatibility. Only `name` and `description` are read by AI agents. Everything else is ignored.

4. **Line count wasn't tracked.** SKILL.md grew organically. Should have enforced 500-line limit from the start.

## Description is Everything

The description field in YAML frontmatter is the single most important line in your skill.

### Why

- It's the PRIMARY trigger mechanism (AI reads this to decide when to activate)
- It's always in context (~100 tokens)
- It determines search ranking on skills.sh
- It's the first thing users see

### Formula

```
[What it does] [When to use] [Specific keywords] NOT for [exclusions]
```

### Bad vs Good

```yaml
# Bad - vague, no keywords, no exclusions
description: Helps with translations

# Good - specific, keyword-rich, clear boundaries
description: Professional AI-powered translation for English-Turkish, Spanish, French, German, Portuguese, Italian, and Russian. Meaning-focused, culturally-aware translations with 98%+ quality. Use when translating text, documents, or content. NOT for language learning, grammar checking, or spell checking.
```

## Progressive Disclosure in Practice

### What We Learned

The 3-level system works exactly as designed:

1. **Level 1 (Metadata):** Always loaded. ~100 tokens. This triggers the skill.
2. **Level 2 (SKILL.md body):** Loaded when triggered. Keep under 500 lines / 5K tokens.
3. **Level 3 (References):** Loaded on demand. Unlimited size.

### Real Example

translator-ai structure:
- SKILL.md: 200 lines (workflow, principles, file references)
- references/translation-rules.md: 9.7 KB (loaded when translating)
- references/examples-100-complete.md: 40 KB (loaded when AI needs examples)
- references/grammar-comparison.md: 11 KB (loaded for specific language pairs)

The AI agent loads only what it needs. A simple Turkish translation loads translation-rules.md. A complex grammar question also loads grammar-comparison.md.

## User Feedback Loops

### Why They Matter

The difference between a 3-star skill and a 5-star skill is user feedback.

### How to Build Feedback In

1. **GitHub Discussions.** Enable on your repo. Zero friction. Direct feedback.
2. **First-week usage.** Watch how people actually use your skill. Adjust triggers.
3. **Iterate fast.** Update SKILL.md, push to GitHub, skills.sh reflects changes automatically.

### Real Feedback That Changed translator-ai

- "Don't copy English syntax to Turkish" → Rewrote translation rules
- "Keep technical terms in English" → Added rule about terminology
- "Complete sentences, not fragments" → Updated examples
- "Use proper case markers" → Added grammar-specific rules

Each piece of feedback made the skill measurably better.

## SEO and Discovery on skills.sh

### How skills.sh Ranks Skills

1. **Description keywords** - Primary search matching
2. **Weekly installs** - Usage signals quality
3. **GitHub stars** - Community validation
4. **Recency** - Recently updated skills rank higher

### Optimization Checklist

- [ ] Description includes all relevant keywords (tool names, language names, use cases)
- [ ] Description includes NOT clause (prevents false matches)
- [ ] Skill name is descriptive and unique
- [ ] GitHub repo has stars (ask your network)
- [ ] Skill is actively maintained (recent commits)
- [ ] Post about your skill on LinkedIn/Twitter when published

### What Moves the Needle

```
High impact: Description keywords + weekly installs
Medium impact: GitHub stars + recency
Low impact: File count + repo size
```

## GitHub as Infrastructure

### What GitHub Provides

- Version control for your skill
- Discussions for community feedback
- Issues for bug reports
- Stars for social proof
- Insights for traffic analytics (repo → Insights → Traffic)
- Automatic indexing by skills.sh

### Setup Checklist

- [ ] Public repository (required for skills.sh)
- [ ] Discussions enabled (Settings → Features → Discussions)
- [ ] Proper .gitignore (no .DS_Store, no node_modules)
- [ ] Clean commit history (meaningful commit messages)

## Quality Over Quantity

### The 80/20 of Skill Quality

These 3 things account for 80% of skill quality:

1. **Accurate description with keywords** - Gets discovered AND triggered correctly
2. **Working scripts** - Deterministic, no TODOs, actually tested
3. **Concise SKILL.md** - Under 500 lines, decision trees, not documentation dumps

### What Doesn't Matter

- Number of reference files (quality > quantity)
- Fancy formatting in SKILL.md
- Comprehensive test suites (users test by using)
- Detailed changelogs (skills should just work)

## What We'd Do Differently

1. **Start with Anthropic's official structure.** Only SKILL.md + resources. No auxiliary files.
2. **Write the description first.** Before anything else. It forces clarity on what the skill does.
3. **Enforce 500-line limit from day one.** Move details to references immediately.
4. **Only two frontmatter fields.** name + description. Nothing else.
5. **Validate before every push.** Run the validation script. Every time.
6. **SEO-optimize the description immediately.** Don't wait until after publishing.
