<div align="center">

# asdf-fzf [![Build](https://github.com/pauloedurezende/asdf-fzf/actions/workflows/build.yml/badge.svg)](https://github.com/pauloedurezende/asdf-fzf/actions/workflows/build.yml) [![Lint](https://github.com/pauloedurezende/asdf-fzf/actions/workflows/lint.yml/badge.svg)](https://github.com/pauloedurezende/asdf-fzf/actions/workflows/lint.yml)

[fzf](https://github.com/junegunn/fzf) plugin for the [asdf version manager](https://asdf-vm.com).

A command-line fuzzy finder.

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar` and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)

**Note:** This plugin downloads pre-compiled binaries, making installation fast and not requiring any build dependencies like Rust or Go.

# Install

Plugin:

```shell
asdf plugin add fzf
# or
asdf plugin add fzf https://github.com/pauloedurezende/asdf-fzf.git
```

fzf:

```shell
# Show all installable versions
asdf list-all fzf

# Install specific version
asdf install fzf latest

# Show installed versions
asdf list fzf

# Set a version globally (in your home ~/.tool-versions file)
asdf set -u fzf latest

# Now fzf commands are available
fzf --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/pauloedurezende/asdf-fzf/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Paulo Eduardo Rezende](https://github.com/pauloedurezende/)
