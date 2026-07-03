<spec_review_guide>

Adapted from Superpowers' brainstorming skill. Dispatched as a fresh-context subagent so it looks at the written files with genuinely fresh eyes, not the context that produced them.

<when_to_dispatch>

After `.context/OVERVIEW.md` (and `.context/ROADMAP.md` if the project has phases) are written, before presenting the final "project initialized" summary to the user.

</when_to_dispatch>

<dispatch_template>

```
Agent(prompt="
You are a fresh-context reviewer. Verify these project-initialization documents are complete and internally consistent — you are NOT reviewing prose quality.

<files_to_read>
- .context/OVERVIEW.md
- .context/ROADMAP.md (if it exists)
- .context/DECISIONS.md (if it exists)
</files_to_read>

<what_to_check>

| Category | What to look for |
|----------|-------------------|
| Completeness | TODOs, placeholders, '[bracketed]' text left unfilled, incomplete sections |
| Consistency | Internal contradictions — does ROADMAP.md cover something OVERVIEW.md rules out of scope? Do stated constraints conflict with a decision? |
| Clarity | Anything ambiguous enough that a future session with zero prior context could misread it |
| Scope | Is this focused on one project, or does it read like multiple independent projects were merged into one OVERVIEW.md? |

</what_to_check>

<calibration>
Only flag issues that would cause a real problem for a future session reading these files cold. A section that's shorter than another, a stylistic quirk, or a minor wording choice is not an issue. Approve unless there is a genuine gap, contradiction, or placeholder left behind.
</calibration>

<output_format>
## Context Review

**Status:** Approved | Issues Found

**Issues (if any):**
- [File/section]: [specific issue] — [why it matters for a future session]

**Recommendations (advisory, do not block approval):**
- [optional suggestions]
</output_format>
", subagent_type="general-purpose", description="Review .context/ files")
```

</dispatch_template>

<handling_the_return>

**If Approved:** proceed to the completion summary.

**If Issues Found:** fix each issue directly (edit the files in place — do not re-run the whole writing step). No need to re-dispatch the reviewer afterward; fix and move on, the same way Superpowers' inline self-review works. Only re-dispatch if the fixes were substantial enough that you're not confident they resolved everything.

</handling_the_return>

</spec_review_guide>
