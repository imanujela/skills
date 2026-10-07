# Deepening

How to deepen a cluster of shallow modules safely, given its dependencies. Assumes the vocabulary in [SKILL.md](SKILL.md): **module**, **interface**, **seam**, **adapter**.

## Dependency categories

When assessing a candidate for deepening, classify its dependencies. The category determines how the deepened module is tested across its seam.

### 1. In-process

Pure computation, in-memory state, no I/O. Always deepenable: merge the modules and test through the new interface directly. No adapter needed.

### 2. Local-substitutable

Dependencies that have local test stand-ins (PGLite for Postgres, in-memory filesystem). Deepenable if the stand-in exists. The deepened module is tested with the stand-in running in the test suite. The seam is internal; no port at the module's external interface.

### 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary (microservices, internal APIs). Define a **port** (interface) at the seam. The deep module owns the logic; the transport is injected as an **adapter**. Tests use an in-memory adapter. Production uses an HTTP/gRPC/queue adapter.

Recommendation shape: *"Define a port at the seam, implement an HTTP adapter for production and an in-memory adapter for testing, so the logic sits in one deep module even though it's deployed across a network."*

### 4. True external (Mock)

Third-party services (Stripe, Twilio, etc.) you don't control. The deepened module takes the external dependency as an injected port; tests provide a mock adapter.

Every candidate gets exactly one category, stated with the evidence for it (what the dependency is, what stand-in exists). "It's kind of both" means the classification isn't done.

## Seam discipline

- **One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a port unless at least two adapters are justified (typically production + test). A single-adapter seam is just indirection.
- **Internal seams vs external seams.** A deep module can have internal seams (private to its implementation, used by its own tests) as well as the external seam at its interface. Don't expose internal seams through the interface just because tests use them.

## Testing strategy: replace, don't layer

- Old unit tests on shallow modules become waste once tests at the deepened module's interface exist; delete them.
- Write new tests at the deepened module's interface. The **interface is the test surface**.
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors, since they describe behaviour, not implementation. If a test has to change when the implementation changes, it's testing past the interface.

Done when the old shallow-module tests were actually deleted (not left to rot), and every new test invokes the module only through its public interface.

## Verification

A deepening run following this file was correct when:

- Each merged module's dependency is classified into one of the four categories, with the test strategy that category prescribes actually in place.
- The seam has two live adapters (e.g. production + in-memory test) or no port was introduced.
- The old unit tests for the swallowed shallow modules are gone from the suite.
- New tests fail if the interface breaks and pass across internal refactors (spot-check: change an internal name, tests stay green).

## Pitfalls

- **Misclassifying a true external as local-substitutable.** Building a "local stand-in" for Stripe means you're testing a fake, not the bug surface; check whether a real stand-in exists before claiming category 2.
- **The port with one adapter.** Production transport injected but tests still hitting the real thing (or vice versa) is a hypothetical seam; don't ship it.
- **Layering instead of replacing.** Keeping the old shallow-module tests "for safety" doubles maintenance and pins the old shape in place.
- **Leaking internal seams.** Exposing a private test seam through the public interface because it was convenient; the interface is the contract, not the test rig.
