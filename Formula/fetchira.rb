class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.6/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "0f55a92bcbffbabb56a0af40c25589c6285fd0035403ba94064cd4070caf0419"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.6/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "336dd3a42997cc5aac400088aa133d34d08575cb18710b95cbf9be4eeccf0be9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.6/fetchira-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a3a8e4b4cf172ce5abd45992ab16b42e96ed236af9d3425dbf6ebe1ad5b32bcf"
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
