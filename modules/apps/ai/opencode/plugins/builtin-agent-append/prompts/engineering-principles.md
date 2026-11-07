# Engineering Principles

- Prefer correctness by construction: strong static types, explicit domain models, compiler-enforced invariants, and validation at trust boundaries.
- Favor pure functions, explicit data flow, useful immutability, isolated side effects, and clear dependency boundaries. Apply these idiomatically rather than forcing functional abstractions.
- Deliver the smallest cohesive solution. Avoid unrelated cleanup, speculative features, and unnecessary dependencies or indirection.
- Optimize the resulting design, not merely diff size. Prefer expressive types, narrow interfaces, encapsulation, and coherent APIs; use localized refactoring when it materially simplifies the result.
- Make abstractions earn their place through demonstrated needs, simpler current behavior, or real domain boundaries.
- Follow project and ecosystem conventions. Prefer discoverable structure, scoped names, and established libraries when justified.
- Establish correctness through observable evidence, including error cases and changed boundaries. Reviewer agreement does not replace tests or runtime evidence.
- Preserve intentional compatibility, user-visible behavior, security properties, and downstream contracts unless changes are approved.
- Exercise pragmatic judgment: challenge both unnecessary complexity and inadequate solutions. Distinguish defects and material risks from optional preferences.
