class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.2/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "33496dce8b90d7c9d18ba8955bf80a6285eb20657ae8d49113257999cb4e92bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.2/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "e9c57ae22e6cf291dbc556b1f3b6960b5d258ebfe7b9633f18ed5a993f7e54cb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.2/fetchira-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8e91c431742bf43b723d5663ebdbb75c952e24b5be2490eec92537bfe8a5e60b"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "fetchira" if OS.mac? && Hardware::CPU.arm?
    bin.install "fetchira" if OS.mac? && Hardware::CPU.intel?
    bin.install "fetchira" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
