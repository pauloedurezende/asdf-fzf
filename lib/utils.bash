#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/junegunn/fzf"
TOOL_NAME="fzf"
TOOL_TEST="fzf --version"

# Detect the operating system
get_os() {
	local os
	os=$(uname -s | tr '[:upper:]' '[:lower:]')
	case "$os" in
	linux) echo "linux" ;;
	darwin) echo "darwin" ;;
	*) fail "Unsupported operating system: $os" ;;
	esac
}

# Detect and map architecture to fzf naming convention
get_arch() {
	local arch
	arch=$(uname -m)
	case "$arch" in
	x86_64 | amd64) echo "amd64" ;;
	aarch64 | arm64) echo "arm64" ;;
	armv7l) echo "armv7" ;;
	armv6l) echo "armv6" ;;
	armv5*) echo "armv5" ;;
	*) fail "Unsupported architecture: $arch" ;;
	esac
}

# Check if required tools are available
check_dependencies() {
	if ! command -v curl >/dev/null 2>&1; then
		fail "curl is required but not installed"
	fi
	if ! command -v tar >/dev/null 2>&1; then
		fail "tar is required but not installed"
	fi
}

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url os arch
	version="$1"
	filename="$2"

	# Check dependencies before attempting download
	check_dependencies

	# Detect system OS and architecture
	os=$(get_os)
	arch=$(get_arch)

	# Construct the binary release URL (fzf uses 'v' prefix in tags)
	url="$GH_REPO/releases/download/v${version}/fzf-${version}-${os}_${arch}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version for $os/$arch..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"

		# Copy the fzf binary to the install path
		# Binary releases contain the fzf executable directly
		if [ -f "$ASDF_DOWNLOAD_PATH/fzf" ]; then
			cp "$ASDF_DOWNLOAD_PATH/fzf" "$install_path/"
			chmod +x "$install_path/fzf"
		else
			fail "fzf binary not found in $ASDF_DOWNLOAD_PATH"
		fi

		# Verify the fzf executable exists and is executable
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
