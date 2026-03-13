# jak — AI Task Script Generator

A PowerShell tool that turns a plain English description of a task into a reusable, rerunnable script. Describe what you need done — "convert all mp4s to mp3," "sort my files by type," "read this receipt" — and jak generates a working script you can run again whenever you need it.

The idea isn't "build me an app." It's closer to a personal command library that writes itself: describe a task once, and jak produces a script you can invoke by name from then on. The generated scripts live in `~/.jak/jaks/` and can be rerun with `Invoke-Jak`.

## How It Works

1. Run `New-Jak -name "mp4tomp3" -details "Convert all mp4 files in the current directory to mp3"`
2. jak fills a prompt template with the task name, description, and target language (Python)
3. The prompt is sent to the OpenAI API (originally Codex `code-davinci-002`, later GPT-4)
4. The AI generates a build script that defines the task's files in memory
5. jak writes the files to disk and runs the task immediately
6. From then on, run `Invoke-Jak mp4tomp3` to reuse it

`Repair-Jak` lets you fix a generated script that has issues.

## Example Jaks

Some of the generated task scripts in the author's personal `~/.jak/jaks/` folder:

`mp4tomp3` · `webp2png` · `findcsv` · `receipt` · `receiptreader` · `DriveUsage` · `FindSongs` · `ListFilesNice` · `updates` · `clearit` · `mouseshare` · `doccam` · `yolocam` · `gcalc` · `mail` · `gmail` · `nav-files-nice`

These illustrate the intent: everyday tasks described in plain English, turned into reusable scripts.

## How Early Was This?

This project was first committed on **July 13, 2023**. The core concept — describe a task in plain English and get a reusable script you can run again — predates the mainstream "vibe coding" movement by over a year. Here's how the author's timing compares:

| Date | Project |
|---|---|
| **Jun 2021** | **GitHub Copilot** technical preview — line/function-level autocomplete, not whole-program generation |
| **Jan 2023** | **Cursor** first release — AI code editor for editing existing code |
| **May 2023** | **Smol Developer** (swyx) — "whole program synthesis" from a spec (~200 LOC). First tool in this specific space. |
| **Jun 2023** | **GPT Engineer** (Anton Osika) — "one prompt generates a codebase." Open source. |
| **Jul 2023** | **This project (jak)** — describe a task, get a rerunnable script. Used raw Codex completions API. |
| **Oct 2023** | **Vercel v0** beta — AI-powered frontend component generation from descriptions |
| **Mar 2024** | **Devin** (Cognition Labs) — "first AI software engineer," autonomous coding agent |
| **Oct 2024** | **Bolt.new** (StackBlitz) — full-stack app generation from prompts in the browser |
| **Nov 2024** | **Windsurf** (Codeium) — agentic AI code editor |
| **Late 2024** | **Lovable** (rebrand of GPT Engineer) — web app builder from descriptions |
| **Feb 2025** | **Andrej Karpathy coins "vibe coding"** — the term enters mainstream vocabulary. Collins Word of the Year 2025. |
| **May 2025** | **Claude Code** GA (Anthropic) — agentic CLI coding tool |

jak was built **19 months before the term "vibe coding" was even coined**, and sits in the same narrow window (May–July 2023) as Smol Developer and GPT Engineer — the first wave of tools to implement the "describe it in English, get working code" paradigm. All three appeared independently within weeks of each other, before the concept went mainstream.

What distinguishes jak from the others in that wave is the emphasis on *reusability* — the generated scripts aren't throwaway demos, they're named task scripts that accumulate into a personal command library. This concept of a self-building automation toolkit still doesn't have a clean mainstream equivalent.

The original implementation is notable for using the raw OpenAI Codex completion API (`code-davinci-002`) rather than the chat API — a lower-level approach that iteratively built up the generated script through multiple completion calls with continuation.
