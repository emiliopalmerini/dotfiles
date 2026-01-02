{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.claude;
in
{
  options = {
    claude.enable = mkEnableOption "Enable Claude Code configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.claude-code ];

    home.file.".claude/CLAUDE.md".text = ''
      # Git Commit Guidelines

      ## Core Principles

      ### 1. No Author Attribution in Commit Messages
      Do not include Claude information in the commit message itself.

      ### 2. No Emojis
      Keep commit messages professional and text-only. Emojis can cause parsing issues with some Git tools and reduce readability in terminal environments.

      ### 3. Use Conventional Commits Format
      Follow the Conventional Commits specification for all commit messages:

      **Format:** `type(scope): description`

      **Common types:**
      - `feat`: New feature or functionality
      - `fix`: Bug fix
      - `docs`: Documentation changes only
      - `style`: Code formatting, missing semicolons, etc. (no functional changes)
      - `refactor`: Code restructuring without changing functionality
      - `test`: Adding or modifying tests
      - `chore`: Maintenance tasks, dependency updates, build changes

      **Examples:**
      - `feat(frontend): add user authentication flow`
      - `fix(api): resolve null pointer exception in user service`
      - `docs(readme): update installation instructions`
      - `chore(deps): upgrade React to version 18.2`

      ### 4. Atomic Commits
      Each commit should represent exactly one logical change. This principle ensures:
      - Clear project history
      - Easy rollback of specific changes
      - Simplified code review process
      - Better bisecting for debugging

      **What makes a commit atomic:**
      - It addresses a single concern
      - It's complete and functional on its own
      - It doesn't mix unrelated changes
      - It can be reverted without affecting other functionality

      ### 5. Separate Different Changes
      Never combine unrelated modifications in a single commit. Each distinct change deserves its own commit.

      **Example scenario:**
      If you're working on a feature and notice an unrelated issue:
      1. First commit: `chore(git): update .gitignore for node_modules`
      2. Second commit: `feat(frontend): implement search functionality`

      These are two separate concerns and should never be combined, even if you worked on them in the same session.

      ## Best Practices

      - Commit immediately after completing each unit of work
      - Write commit messages in present tense imperative mood ("add feature" not "added feature")
      - Keep the subject line under 50 characters when possible
      - If more context is needed, add a blank line after the subject and write a detailed body
      - Review your changes before committing to ensure they're truly atomic

      ## Why This Matters

      Atomic, well-formatted commits create a readable project history that serves as documentation. When debugging issues months later, clear commit messages help identify when and why changes were made, making maintenance significantly easier.
      - I write in italian, but you can respond in english
      - do not write dumb comment when option is clear enough
      - do not co-author commit
    '';

    home.file.".claude/settings.json".text = builtins.toJSON {
      permissions = {
        allow = [
          "Bash(ripgrep:*)"
          "Bash(python3:*)"
        ];
        deny = [];
        ask = [];
      };
      alwaysThinkingEnabled = true;
      enabledPlugins = {
        "gopls-lsp@claude-plugins-official" = true;
      };
    };

    home.file.".claude/skills/conjure/SKILL.md".text = ''
      ---
      name: conjure
      description: Scaffold a new vertical slice module with CQRS pattern using grimoire conjure. Use when asked to create a new module, feature, or entity with commands/queries structure.
      allowed-tools: Bash(grimoire:*), Bash(go build:*)
      ---

      # Conjure - Module Scaffolding Spell

      Summons a new vertical slice module with complete directory structure following CQRS pattern.

      ## Prerequisites

      Must be run from a Go project root containing:

      - `internal/` directory
      - `go.mod` file

      If grimoire is not in PATH, build it first:

      ```bash
      go build -o grimoire . && ./grimoire conjure ...
      ```

      ## Usage

      ```bash
      grimoire conjure <module-name> [flags]
      ```

      Ask questions to decide which flag to use. You can ask for multiple flags.

      ## Flags

      | Flag            | Short | Default | Description                                        |
      | --------------- | ----- | ------- | -------------------------------------------------- |
      | `--transport`   | `-t`  | `http`  | Transport layers: `http`, `amqp` (comma-separated) |
      | `--api`         | `-a`  | `json`  | API response format: `json`, `html`                |
      | `--crud`        | `-c`  | `true`  | Generate CRUD commands and queries                 |
      | `--persistence` | `-p`  | (none)  | Persistence layer: `sqlite`, `postgres`, `mongodb` |

      ## Examples

      Basic module with HTTP transport and JSON API:

      ```bash
      grimoire conjure order
      ```

      Module with multiple transports and HTML (HTMX) views:

      ```bash
      grimoire conjure user --transport=http,amqp --api=html
      ```

      Module with PostgreSQL persistence:

      ```bash
      grimoire conjure product --persistence=postgres
      ```

      Full-featured module:

      ```bash
      grimoire conjure customer --transport=http,amqp --api=html --crud --persistence=postgres
      ```

      ## Generated Structure

      ```
      internal/<module>/
      ├── commands/       # Command handlers (Create, Update, Delete)
      ├── queries/        # Query handlers (Get, List)
      ├── transport/
      │   ├── http/       # Chi router handlers
      │   └── amqp/       # RabbitMQ consumers (if --transport includes amqp)
      ├── persistence/    # Repository interface
      └── views/          # HTMX templates (if --api=html)
      ```
    '';

    home.file.".claude/skills/transmute/SKILL.md".text = ''
      ---
      name: transmute
      description: Convert data between formats (JSON, YAML, TOML, XML, CSV, Markdown, HTML) using grimoire transmute. Use when asked to convert, transform, or render data files.
      allowed-tools: Bash(grimoire:*), Bash(./grimoire:*), Bash(go build:*)
      ---

      # Transmute - Format Conversion Spell

      Converts data between different formats. All formats support both reading and writing.

      ## Prerequisites

      If grimoire is not in PATH, build it first:

      ```bash
      go build -o grimoire . && ./grimoire transmute ...
      ```

      ## Usage

      ```bash
      grimoire transmute <input-file> --to <format> [flags]
      cat data.json | grimoire transmute --from json --to yaml
      ```

      ## Flags

      | Flag       | Short | Default   | Description                                         |
      | ---------- | ----- | --------- | --------------------------------------------------- |
      | `--to`     | `-t`  | (required)| Output format: json, yaml, toml, xml, csv, md, html |
      | `--from`   | `-f`  | auto      | Input format (auto-detected from extension)         |
      | `--output` | `-o`  | stdout    | Output file path                                    |

      ## Supported Formats

      | Format   | Extension  | Read | Write |
      | -------- | ---------- | ---- | ----- |
      | JSON     | .json      | Yes  | Yes   |
      | YAML     | .yaml/.yml | Yes  | Yes   |
      | TOML     | .toml      | Yes  | Yes   |
      | XML      | .xml       | Yes  | Yes   |
      | CSV      | .csv       | Yes  | Yes   |
      | Markdown | .md        | Yes  | Yes   |
      | HTML     | .html      | Yes  | Yes   |

      ## Examples

      Data format conversions:

      ```bash
      grimoire transmute config.json --to yaml
      grimoire transmute settings.yaml --to toml
      grimoire transmute data.xml --to json
      grimoire transmute users.json --to xml
      ```

      Document rendering (auto-detects structure):

      ```bash
      grimoire transmute users.json --to markdown    # Arrays render as tables
      grimoire transmute config.json --to html       # Objects render as key-value
      ```

      Parse documents back to data:

      ```bash
      grimoire transmute table.html --to json        # HTML tables to JSON
      grimoire transmute data.md --to yaml           # Markdown tables to YAML
      ```

      CSV conversions:

      ```bash
      grimoire transmute users.json --to csv
      grimoire transmute data.csv --to json
      ```

      Stdin/stdout piping:

      ```bash
      cat data.json | grimoire transmute --from json --to yaml
      curl api.example.com/data | grimoire transmute --from json --to xml
      ```

      Output to file:

      ```bash
      grimoire transmute data.json --to yaml -o output.yaml
      ```

      ## Rendering Rules

      - **Arrays of objects** -> Tables (Markdown/HTML/XML)
      - **Single objects** -> Key-value pairs
      - **Nested structures** -> Hierarchical output
      - **Simple arrays** -> Bulleted lists
      - **XML attributes** -> Preserved as @key in JSON/YAML
    '';
  };
}
