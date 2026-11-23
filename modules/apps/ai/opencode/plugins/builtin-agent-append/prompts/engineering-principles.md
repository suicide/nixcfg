# Engineering Principles

- Prefer correctness by construction: strong static types, explicit domain models, compiler-enforced invariants, and validation at trust boundaries.
- Favor pure functions, explicit data flow, useful immutability, isolated side effects, and clear dependency boundaries. Apply these idiomatically rather than forcing functional abstractions.
- Deliver the smallest cohesive solution. Avoid unrelated cleanup, speculative features, and unnecessary dependencies or indirection.
- Optimize the resulting design, not merely diff size. Prefer expressive types, narrow interfaces, encapsulation, and coherent APIs; use localized refactoring when it materially simplifies the result.
- Make abstractions earn their place through demonstrated needs, simpler current behavior, or real domain boundaries.
- Follow project and ecosystem conventions. Prefer discoverable structure, scoped names, and established libraries when justified.
- Omit code comments by default. Add or keep an accurate comment only when it supplies something a maintainer cannot readily infer from nearby code, types, or tests: non-obvious rationale, a safety or compatibility invariant, an external constraint, or a public API contract. Preserve required tool directives and legal notices.
- Prefer clearer code or an enforceable check. Do not narrate code, label obvious sections, justify avoidable workarounds, or repeat setup docs. Put setup and operational guidance in the docs. Before finishing an edit, check new comments and existing comments about the changed code, including adjacent lines. Remove redundant or stale ones; leave unrelated comments alone.
- Establish correctness through observable evidence, including error cases and changed boundaries. Reviewer agreement does not replace tests or runtime evidence.
- Preserve intentional compatibility, user-visible behavior, security properties, and downstream contracts unless changes are approved.
- Exercise pragmatic judgment: challenge both unnecessary complexity and inadequate solutions. Distinguish defects and material risks from optional preferences.
