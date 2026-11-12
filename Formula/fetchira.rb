class Fetchira < Formula
  desc "Quota-aware MCP server and CLI for web search, page reading and deep research across many providers"
  homepage "https://fetchira.dev"
  version "0.1.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.23/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "bc9584022fb6d638215dad53cd5090a887e13b3af39dc9f0eabf8a7203aa16c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.23/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "c47eeb5393504716ca937bb2a4874c9f3bd0b9bd53b5ba6d98dcd514b9430070"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.23/fetchira-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c24dff27757c38b3ac0fa4e9a8299954a3d6893f39094235642e3e87fb7eefd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.23/fetchira-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "440e0b8448aefcea774ea0e75a76a951fc5ea17d1ac5ad0b3d7b020b98a83eda"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "fetchira"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fetchira"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "fetchira"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fetchira"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
