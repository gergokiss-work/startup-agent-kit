# Knowledge Directory

This directory contains project-specific reference documentation and knowledge base files.

## Purpose

Store persistent knowledge that Claude should reference when working on this project:

- **Architecture decisions** - ADRs, design rationale
- **Domain knowledge** - Business rules, domain concepts
- **API documentation** - Internal API references
- **Integration guides** - How to work with external services
- **Compliance requirements** - Security standards, regulations
- **Coding standards** - Project-specific conventions

## File Organization

| File Pattern | Purpose |
|--------------|---------|
| `architecture-*.md` | Architecture Decision Records (ADRs) |
| `domain-*.md` | Domain-specific knowledge |
| `api-*.md` | API documentation |
| `compliance-*.md` | Compliance and security requirements |
| `standards-*.md` | Coding standards and conventions |

## Usage

When Claude needs domain-specific knowledge, it will reference files in this directory.
Keep files focused and well-organized for efficient lookup.

## Examples

```
knowledge/
├── architecture-database-choice.md
├── domain-authentication-flow.md
├── api-internal-services.md
├── compliance-gdpr-requirements.md
└── standards-error-handling.md
```
