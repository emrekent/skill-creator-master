# Skill Creation Anti-Patterns

## Table of Contents
- 1. Documentation Dump
- 2. Missing NOT Clause
- 3. Phantom Tools
- 4. Template Soup
- 5. Everything Skill
- 6. Auxiliary File Bloat
- 7. Trigger Blindness
- 8. Context Window Hog
- 9. Premature Abstraction
- 10. Stale Knowledge

## 1. Documentation Dump

**What it looks like:** SKILL.md is 800+ lines. Reads like a tutorial, not an instruction set.

**Why it's wrong:** SKILL.md has a 500-line limit. Every line costs tokens from the shared context window. AI agents are already smart—they don't need verbose explanations.

**Fix:** Keep SKILL.md under 500 lines. Move detailed content to `references/`. Use decision trees, not paragraphs.

```
Bad:  SKILL.md (800 lines of tutorials and explanations)
Good: SKILL.md (200 lines of workflow) + references/details.md (600 lines)
```

## 2. Missing NOT Clause

**What it looks like:**
```yaml
description: Helps with image processing
```

**Why it's wrong:** Without exclusions, the skill triggers on any image-related query—even ones it can't handle. False triggers waste tokens and confuse users.

**Fix:**
```yaml
description: CLIP semantic image search. Use for image-text matching, zero-shot classification. NOT for image generation, editing, OCR, or object counting.
```

## 3. Phantom Tools

**What it looks like:** SKILL.md says "Run scripts/analyze.py" but the file doesn't exist.

**Why it's wrong:** AI agent tries to execute a non-existent script. User gets an error. Trust is broken.

**Fix:** Run `validate_skill.sh` before publishing. It checks that every referenced file exists.

## 4. Template Soup

**What it looks like:**
```python
# scripts/process.py
def process(input):
    # TODO: implement processing logic
    pass
```

**Why it's wrong:** Scripts that don't work are worse than no scripts. The AI agent will try to run them and fail.

**Fix:** Ship working code or don't ship scripts at all. Every script must actually execute and produce correct output.

## 5. Everything Skill

**What it looks like:** One skill that handles all photo operations—editing, analysis, composition, color theory, collage, event detection.

**Why it's wrong:** Too broad. Activates too often. Quality suffers because no single SKILL.md can cover everything well in 500 lines.

**Fix:** Split into focused skills. One domain expertise per skill.

```
Bad:  photo-master (handles everything)
Good: photo-composition, photo-color-theory, photo-collage (focused skills)
```

Real case study: An 800-line photo skill was split into 5 focused skills. Each performed better than the monolith.

## 6. Auxiliary File Bloat

**What it looks like:**
```
my-skill/
├── SKILL.md
├── README.md
├── INSTALLATION.md
├── CHANGELOG.md
├── TESTING.md
├── LICENSE.md
├── QUICK_REFERENCE.md
└── references/
```

**Why it's wrong:** Per Anthropic's official guidance, skills should only contain SKILL.md + resources. Auxiliary documentation adds clutter and confusion. AI agents don't read README or CHANGELOG.

**Fix:** Delete all auxiliary files. Keep only:
- SKILL.md (required)
- scripts/ (optional)
- references/ (optional)
- assets/ (optional)

## 7. Trigger Blindness

**What it looks like:** Description says what the skill does but not when to trigger it.

```yaml
# Bad - what but not when
description: Professional translation skill

# Good - what AND when
description: Professional translation for English-Turkish and 6 more languages. Use when translating text, documents, or content between languages. Triggers on "translate to", "translation", language names. NOT for language learning or grammar checking.
```

**Why it's wrong:** The description is the PRIMARY trigger mechanism. If it doesn't include trigger keywords, the skill won't activate when users need it.

**Fix:** Include specific trigger keywords and phrases in the description. Test by imagining what users would type.

## 8. Context Window Hog

**What it looks like:** SKILL.md loads 5K tokens of instructions, then immediately reads 3 reference files (15K more tokens). Total: 20K tokens consumed before doing anything.

**Why it's wrong:** The context window is shared with conversation history, other skills, and the actual task. Hogging it makes everything slower and more expensive.

**Fix:** Progressive disclosure. SKILL.md loads ~5K tokens max. References load ONLY when the AI agent determines they're needed.

## 9. Premature Abstraction

**What it looks like:** Creating a "skill framework" or "skill platform" before building a single real skill. Designing for 50 language pairs when you've validated 1.

**Why it's wrong:** You don't know what patterns will emerge until you've built 2-3 real skills. Abstractions built on theory are wrong.

**Fix:** Build specific skills first. Extract patterns after building 3+ skills. Abstractions should come from experience, not imagination.

## 10. Stale Knowledge

**What it looks like:** Skill advises using `useEffect` as a replacement for `componentDidMount` without mentioning React 18's double-invoke behavior.

**Why it's wrong:** Temporal knowledge decays. What was correct in 2023 may be actively harmful in 2026. AI training data contains outdated patterns.

**Fix:** Date your knowledge. Include temporal markers:
```markdown
**Pre-2024:** useEffect ran once on mount
**2024+:** useEffect runs TWICE in dev mode (React 18 strict mode)
**Current best practice:** Use refs for run-once effects
```

## Quick Detection Checklist

| Anti-Pattern | Detection | Fix |
|-------------|-----------|-----|
| Documentation Dump | SKILL.md > 500 lines | Move to references/ |
| Missing NOT Clause | No "NOT for" in description | Add exclusions |
| Phantom Tools | Referenced file doesn't exist | Delete reference or create file |
| Template Soup | TODO in scripts | Ship working code or remove |
| Everything Skill | > 3 distinct domains in one skill | Split into focused skills |
| Auxiliary File Bloat | README, LICENSE, CHANGELOG exist | Delete them |
| Trigger Blindness | No keywords in description | Add trigger phrases |
| Context Window Hog | > 5K tokens loaded immediately | Use progressive disclosure |
| Premature Abstraction | Framework before first skill | Build specifics first |
| Stale Knowledge | No dates on technical claims | Add temporal markers |
