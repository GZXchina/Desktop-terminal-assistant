# Technical Scheme - Architect Sage Framework

## Overview
This project implements an AI-driven architectural framework based on the **Architect Sage** persona. It integrates a structured **Thinking Mode** system (skills) to guide AI assistants in making high-quality, scalable, and evolvable technical decisions.

## Core Components

### 1. Thinking Engine (Skills)
- **Location**: [skills/](file:///c:/Users/DK/Desktop/桌面终端助理/skills)
- **Purpose**: Provides a knowledge base of mental models (First Principles, Inverse Thinking, etc.) and specialized engineering skills (Architecture, Performance, Debugging).
- **Format**: Each skill is defined in a `SKILL.md` file with core definitions, execution flows, and practical examples.

### 2. Project Rule Engine (Trae)
- **Location**: [.trae/rules/project_rules.md](file:///c:/Users/DK/Desktop/桌面终端助理/.trae/rules/project_rules.md)
- **Purpose**: Defines the operational constraints and behavioral persona for the AI assistant within this project.
- **Key Constraints**:
    - **Code Observability**: Mandatory logging.
    - **Complexity Control**: Simplify before adding.
    - **Operation Logging**: Mandatory tracking in `refreshing.txt`.

### 3. Application - RuoYi-App
- **Tech Stack**: Uni-app (Vue 2), Vuex, SCSS.
- **Integration**: The AI assistant applies the above thinking modes to manage the RuoYi-App codebase, ensuring architectural integrity during feature iteration.

## Operational Standards
- **File Tracking**: All operations logged via PowerShell command to `refreshing.txt`.
- **Architecture Updates**: Major changes reflected in this `tech_scheme.md`.
