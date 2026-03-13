# jak — AI Program Generator

A PowerShell tool that generates complete, runnable programs from a short natural language description. Give it a name and a one-sentence description, and it produces a working application.

## How It Works

1. Run `jak -name "MyApp" -details "A calculator app"`
2. jak fills a prompt template with the app name, description, and target language (Python)
3. The prompt is sent to the OpenAI API (originally Codex `code-davinci-002`, later GPT-4)
4. The AI generates a PowerShell build script that defines application files in memory
5. jak executes the build script, writes the files to disk, and runs the app

The tool also includes `Invoke-Jak` (run a previously generated app) and `Repair-Jak` (fix a generated app that has issues).

## How Early Was This?

This project was first committed on **July 13, 2023**. The core concept — describe a program in plain English and get a complete, runnable application — is what later became known as **"vibe coding."** Here's how the author's timing compares to the broader ecosystem:

| Date | Project |
|---|---|
| **Jun 2021** | **GitHub Copilot** technical preview — line/function-level autocomplete, not whole-program generation |
| **Jan 2023** | **Cursor** first release — AI code editor for editing existing code |
| **May 2023** | **Smol Developer** (swyx) — "whole program synthesis" from a spec (~200 LOC). First tool in this specific space. |
| **Jun 2023** | **GPT Engineer** (Anton Osika) — "one prompt generates a codebase." Open source. |
| **Jul 2023** | **This project (jak)** — describe a program, get a working app. Used raw Codex completions API. |
| **Oct 2023** | **Vercel v0** beta — AI-powered frontend component generation from descriptions |
| **Mar 2024** | **Devin** (Cognition Labs) — "first AI software engineer," autonomous coding agent |
| **Oct 2024** | **Bolt.new** (StackBlitz) — full-stack app generation from prompts in the browser |
| **Nov 2024** | **Windsurf** (Codeium) — agentic AI code editor |
| **Late 2024** | **Lovable** (rebrand of GPT Engineer) — web app builder from descriptions |
| **Feb 2025** | **Andrej Karpathy coins "vibe coding"** — the term enters mainstream vocabulary. Collins Word of the Year 2025. |
| **May 2025** | **Claude Code** GA (Anthropic) — agentic CLI coding tool |

jak was built **19 months before the term "vibe coding" was even coined**, and sits in the same narrow window (May–July 2023) as Smol Developer and GPT Engineer — the first wave of tools to implement the "describe it and get a whole program" paradigm. All three appeared independently within weeks of each other, before the concept went mainstream.

The original implementation is notable for using the raw OpenAI Codex completion API (`code-davinci-002`) rather than the chat API — a lower-level approach that iteratively built up the generated program through multiple completion calls with continuation.
