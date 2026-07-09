# Homebrew Tap for Fabric

Official [Homebrew](https://brew.sh) tap for [Fabric](https://github.com/pdlc-os/fabric),
the container-based orchestration platform for concurrent LLM code agents.

## Install

```bash
brew install pdlc-os/fabric/fabric
```

Or tap first, then install:

```bash
brew tap pdlc-os/fabric
brew install fabric
```

The formula installs a prebuilt binary with the web UI assets embedded. To get
started:

```bash
fabric server start
```

and follow the onboarding wizard in your browser.

### Development builds

To build the current `main` branch from source (requires Go and Node):

```bash
brew install --HEAD pdlc-os/fabric/fabric
```

## Upgrading

```bash
brew upgrade fabric
```

## Maintenance

`Formula/fabric.rb` is generated — do not edit it here. It is rendered from
[`packaging/homebrew/fabric.rb.tmpl`](https://github.com/pdlc-os/fabric/blob/main/packaging/homebrew/fabric.rb.tmpl)
in the main repository and pushed by the `homebrew` job of its release
workflow whenever a release is published.

## Issues

Report problems with Fabric itself at
[pdlc-os/fabric](https://github.com/pdlc-os/fabric/issues). Use this repo's
issues only for packaging problems.
