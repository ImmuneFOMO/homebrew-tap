class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.16/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "6dc185bced7b2adb5e9f0befa563a9283e6ee622f018dca8f539708bb8ae43e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.16/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "81ecb795de1a4ac302cab9de42adf08904e48d998f694dd4cc94eb8a4b78c7d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.16/fetchira-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f84a24d18d76702b39526886f95b1b649aade7ddeefae74244780e049a44b36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.16/fetchira-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9557166e26366a9cff9aa71228198cc52037d5c0255893c90f8ac91dfb83dbaf"
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
