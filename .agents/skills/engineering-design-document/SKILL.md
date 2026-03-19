---
name: engineering-design-document
description: Describes how to write an Engineering Design Document (EDD) that outlines the design and architecture of a product or feature clearly and concisely. Use this skill when writing or reviewing an EDD.
---

# Overview

An engineering design document (EDD) should include details about the system architecture, data flow, component interactions, and any relevant technical decisions. It serves as a blueprint for the development team, providing a clear and concise overview of the technical aspects of the project. An EDD is a comprehensive document that outlines the design and architecture of a product or feature.

The goal is to create or update an EDD that is clear, concise, and outlines the exact details of the intended implementation.

# When to use

Use this skill when writing or reviewing an EDD for a product or feature.

# Instructions for new EDDs (use this when writing **NEW** EDDs)

## Template

1. **Title**: The title of the EDD should be descriptive and concise, clearly indicating the purpose of the document.
2. **Overview**: Provide a brief summary of the requested feature or problem statement.
3. **Background**: Include any relevant context related to the problem statement, including
    1. Current state of the system
    2. Integration points
4. **Design**: This section should include a detailed description of the proposed design, including:
    1. System architecture
    2. Data flow
    3. Component interactions
    4. Any relevant technical decisions
5. **Implementation Plan**: Outline the steps required to implement the proposed design.
    1. This should always be laid out in a "milestones" structure.
    2. Milestones are deliverables that are a) sequential (later milestones depend on completion of previous milestones, b) independently deployable (each milestone is a self-contained body of work that may be deployed with proper validation or fallbacks), and c) verifiable (milestones have clear acceptance criteria that can be tested and verified before deployment).
    4. Each milestone should have a clear testing plan (if necessary).
    3. Each milestone may have any number of small tasks that may or may not be parallelizable. Each task is a small body of work (implementing a (small number of) function(s), writing tests, etc. Tasks do not necessarily need the context of the higher-level design; assume each task may be completed by a competent engineer without context of the overall design.
6. **Alternative proposals**: If you have any alternative designs that should be considered, summarize them here.
7. **Open questions**: If there are any open questions that need to be resolved before implementation, list them here.
