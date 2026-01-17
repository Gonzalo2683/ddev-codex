# ddev-codex

[![tests](https://github.com/Gonzalo2683/ddev-codex/actions/workflows/tests.yml/badge.svg)](https://github.com/Gonzalo2683/ddev-codex/actions/workflows/tests.yml)
![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

**OpenAI Codex CLI addon for DDEV** - Run the OpenAI Codex coding agent directly inside your DDEV containers.

[Codex CLI](https://github.com/openai/codex) is a lightweight coding agent that runs in your terminal, built in Rust for speed and efficiency.

## Installation

```bash
ddev add-on get Gonzalo2683/ddev-codex
ddev restart
```

## Authentication

### ChatGPT Login (Device Auth) - Recommended

Since Codex runs inside a container, the standard browser authentication won't work (the callback redirects to `localhost` which doesn't resolve inside the container). Use **device authentication** instead:

**Step 1:** Enable device code authorization in ChatGPT settings

Go to [ChatGPT Settings > Security](https://chatgpt.com/settings) and enable **"Enable device code authorization for Codex"**.

**Step 2:** Run the login command

```bash
ddev codex login --device-auth
```

**Step 3:** Complete authentication

The command will display a URL and a code. Open the URL in your browser, sign in with your ChatGPT account, and enter the provided code.

Your credentials are stored in `.ddev/codex/` and persist across `ddev restart`.

### API Key (Alternative)

If you prefer using an API key, add it to `.ddev/.env`:

```bash
OPENAI_API_KEY=sk-your-api-key-here
```

Then restart: `ddev restart`

## Usage

```bash
# Start Codex interactive mode
ddev codex

# Get help
ddev codex --help

# Run a specific prompt
ddev codex "explain this code"
```

## Configuration

### Changing Codex Version

Edit `.ddev/web-build/Dockerfile.codex` and change the version:

```dockerfile
ARG CODEX_VERSION=0.87.0
```

Then rebuild: `ddev restart`

## Troubleshooting

### Codex command not found

Run `ddev restart` to rebuild the container with Codex CLI installed.

### Authentication callback error

If you see a `localhost` callback URL that doesn't work, you're using the wrong auth method. Use `ddev codex login --device-auth` instead.

### Device auth not working

Make sure you've enabled **"Enable device code authorization for Codex"** in [ChatGPT Settings > Security](https://chatgpt.com/settings).

### Architecture not supported

Codex CLI requires x86_64 or arm64 architecture. Check with `uname -m`.

## Contributing

Contributions are welcome! Please open an issue or pull request.

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.

**Maintained by [@Gonzalo2683](https://github.com/Gonzalo2683)**
