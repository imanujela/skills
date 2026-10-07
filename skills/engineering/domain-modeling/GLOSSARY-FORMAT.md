# GLOSSARY.md Format

## Structure

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{One or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only include terms specific to this project's context.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively. Before adding a term, ask: is this a concept unique to this context, or a general programming concept? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.

An entry is done when it has all three parts (term, 1–2 sentence definition, `_Avoid_` list) and a grep of the codebase's other words for the concept would land in `_Avoid_`, not in a definition.

## Single vs multi-context repos

**Single context (most repos):** One `GLOSSARY.md` at the repo root.

**Multiple contexts:** A `GLOSSARY-MAP.md` at the repo root lists the contexts, where they live, and how they relate to each other:

```md
# Glossary Map

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md): receives and tracks customer orders
- [Billing](./src/billing/GLOSSARY.md): generates invoices and processes payments
- [Fulfillment](./src/fulfillment/GLOSSARY.md): manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

The skill infers which structure applies:

- If `GLOSSARY-MAP.md` exists, read it to find contexts
- If only a root `GLOSSARY.md` exists, single context
- If neither exists, create a root `GLOSSARY.md` lazily when the first term is resolved

When multiple contexts exist, infer which one the current topic relates to. If unclear, ask.

## Verification

A glossary edit under this format was correct when:

- The entry follows the three-part shape exactly (term, definition, `_Avoid_`), definitions are 1–2 sentences, and none describe behaviour or implementation.
- Every term is context-specific: a general programming concept never got a slot.
- In a multi-context repo, the term landed in the correct context's `GLOSSARY.md`, and `GLOSSARY-MAP.md` relationships still match what the contexts actually emit/consume.
- The `_Avoid_` list covers the synonyms actually heard in this session, not a hypothetical list.

## Pitfalls

- **Definition creep.** A two-sentence definition growing into a paragraph of behaviour; the glossary defines what things ARE, the code defines what they do.
- **Synonym pile-up.** Adding "Purchase" as its own term because the user said it once, instead of putting it under `_Avoid_`.
- **General-concept leak.** "Timeout", "Retry policy", "DTO" in the glossary — terms any repo has are terms this glossary shouldn't define.
- **Map rot.** In multi-context repos, relationships in `GLOSSARY-MAP.md` drifting from the events the code actually emits; re-check on every relationship change.
- **Wrong context file.** Writing a Billing term into the root or an Ordering glossary; the map decides placement, not convenience.
