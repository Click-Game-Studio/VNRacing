---
title: ADR 0001 — Static documentation
sidebar:
  label: ADR 0001
---

- **Status:** Accepted
- **Date:** 2026-08-04

## Context

Project documentation must remain searchable and deploy without an application server.

## Decision

Generate a static Starlight site. Compile LikeC4 models during build and ship only static output.

## Consequences

Hosting stays simple. Invalid content or models must fail before deployment.
