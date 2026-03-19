---
name: dev
description: Describes my software development style and the tools I use. Use this skill when writing, reading, and maintaining any code.
---

# My Development

## Overview

Mimic as close as possible my development style as a software engineer. I use a variety of tools and techniques to ensure that my code is clean, efficient, and maintainable.

## When to Use

Use this skill when writing and reading any code.

## Instructions

### General technical principles

- Prefer to NOT use single-use variables, unless in-lining values would prove egregiously unreadable.
- Prefer meaningful variable names over shortened or acronym names, unless the meaning is widely understood and accepted (e.g. `i` for loop indices).
- Avoid unnecessary nesting of code blocks (e.g. if statements, loops, etc.) where possible, and prefer to use early returns to reduce nesting and improve readability.
- Avoid unnecessary code (e.g. redundant code, dead code, etc.) and prefer to keep the codebase clean and maintainable.
- Always search for existing patterns when writing new code to avoid unnecessary duplication and to maintain a cohesive codebase.
    - However, if you find that the present patterns are less maintainable, readable, and/or secure, develop using best practices, but call out these differences.
- Always consider the security implications of your code and prefer to write secure code that protects against common vulnerabilities and attacks.
- Develop to completeness, NEVER add stubs or placeholders. Address root causes rather than adding bandaids.

### Documentation

- Always consider how the code will be read and maintained by other engineers potentially years from now, and write code that is as clear and self-explanatory as possible without relying on comments or external documentation to explain non-obvious code.

### Encapsulation

- Separate concerns and prefer to write modular code that is organized into functions, classes, and modules that have clear responsibilities and interfaces. Avoid writing monolithic code that is difficult to understand and maintain.
- Generally, prefer composition over inheritance, and prefer to use inheritance only when it is necessary and appropriate for the problem at hand.

### Testing

- Avoid mocking functionality and prefer to write tests that test the actual functionality of the code. If mocking is necessary, prefer to mock as little as possible.
- Avoid writing unnecessary tests (e.g. tests of structure where a type system exists); prefer tests of functionality and behavior.

### Python

- Adhere to the PEP 8 style guide for Python code where possible
- Prefer adding type hints
- Prefer as general typing as possible for input parameters, and as specific typing as possible for return types
    - For example, if a function just needs an iterable parameter, use `Iterable` instead of `list` or `set`. And if a function returns a list of strings, use `list[str]` instead of `list[Any]`
- Avoid use of linting/formatting `ignore`s, `cast`ing types, or annoting with the `Any` type.
