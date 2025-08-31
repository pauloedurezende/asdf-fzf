# Contributing

## Prerequisites

Before testing locally, make sure you have:

- **asdf** installed and configured
- Basic development tools: `bash`, `curl`, `tar`

## Testing Locally

```shell
asdf plugin test fzf <path-to-plugin> --asdf-tool-version 0.65.2 "fzf --version"
```

**Note:** The test downloads pre-compiled binaries, making it fast compared to tools that compile from source.

Tests are automatically run in GitHub Actions on push and PR.
