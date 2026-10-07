---
name: to-spec
description: "Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed."
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec. Do NOT interview the user; just synthesize what you already know.

The issue tracker and triage label vocabulary should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

## Process

1. **Explore the repo** to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary throughout the spec, and respect any ADRs in the area you're touching. *Done when:* you can describe, in the project's own terms, the current code that this feature touches.

2. **Sketch out the seams** at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Check with the user that these seams match their expectations. *Done when:* the user has confirmed the proposed seams; you don't write the spec's Testing Decisions against seams you haven't agreed.

3. **Write the spec** using the template below, then publish it to the project issue tracker. Apply the `ready-for-agent` triage label - no need for additional triage. *Done when:* the spec exists at its tracker path/URL, the `ready-for-agent` label is applied, and the user has been told where it landed.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>

## Verification

- **No interview.** The spec is synthesized entirely from the conversation + codebase; you asked no clarifying questions to fill it.
- **Vocabulary.** User stories and decisions use the project's glossary terms, not synonyms.
- **Seams agreed.** The seams in Testing Decisions are the ones the user confirmed in step 2.
- **Durable decisions.** No file paths or code snippets unless a prototype snippet encodes a decision more precisely than prose.
- **Published.** The spec is on the tracker with `ready-for-agent`; the location is named in your reply.

## Pitfalls

- **Specifying file layout**: naming files and folders that will drift the moment implementation starts. Describe behavior and contracts; leave structure to the implementer.
- **Guessing the seams**: proposing seams in Testing Decisions that you didn't confirm with the user in step 2.
- **Interview by inertia**: asking the user to re-explain something already settled in the conversation, instead of synthesizing it.