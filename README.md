# ddev-codex

[![tests](https://github.com/ddev/ddev-codex/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-codex/actions/workflows/tests.yml)
![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

**OpenAI Codex CLI addon for DDEV** - Run the OpenAI Codex coding agent directly inside your DDEV containers.

[Codex CLI](https://github.com/openai/codex) is a lightweight coding agent that runs in your terminal, built in Rust for speed and efficiency.

## Installation

```bash
ddev add-on get ddev/ddev-codex
ddev restart
```

## Authentication

Codex supports two authentication methods:

### Option 1: API Key (Recommended for automation)

Add your OpenAI API key to `.ddev/.env`:

```bash
OPENAI_API_KEY=sk-your-api-key-here
```

Or uncomment and set it in `.ddev/config.codex.yaml`:

```yaml
web_environment:
  - OPENAI_API_KEY=sk-your-api-key-here
```

### Option 2: ChatGPT Login (Device Auth)

For headless environments like containers, use device authentication:

```bash
ddev codex login --device-auth
```

This will display a URL and code. Open the URL in your browser, sign in with your ChatGPT account, and enter the code.

**Note:** Your credentials are stored in `.ddev/codex/` and persist across `ddev restart`.

## Usage

```bash
# Start Codex interactive mode
ddev codex

# Get help
ddev codex --help

# Login with device auth
ddev codex login --device-auth

# Run a specific command
ddev codex "explain this code"
```

## Configuration

### Changing Codex Version

Edit `.ddev/web-build/Dockerfile.codex` and change the version:

```dockerfile
ARG CODEX_VERSION=0.87.0
```

Then rebuild with:

```bash
ddev restart
```

### Environment Variables

Codex respects these environment variables:

| Variable | Description |
|----------|-------------|
| `OPENAI_API_KEY` | Your OpenAI API key |
| `CODEX_HOME` | Custom config directory (default: `~/.codex`) |

## Credential Persistence

Credentials are stored in `.ddev/codex/` which is:
- Mounted as `~/.codex` inside the container
- Automatically gitignored (credentials are not committed)
- Persisted across `ddev restart` and `ddev stop/start`

## Troubleshooting

### Codex command not found

Run `ddev restart` to rebuild the container with Codex CLI installed.

### Authentication issues

1. Check if credentials exist: `ddev exec ls -la ~/.codex/`
2. Re-authenticate: `ddev codex login --device-auth`
3. For API key issues, verify the key in `.ddev/.env`

### Architecture not supported

Codex CLI requires x86_64 or arm64 architecture. Check with `uname -m`.

## Contributing

Contributions are welcome! Please open an issue or pull request.

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.

**Maintained by the DDEV community.**
