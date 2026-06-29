class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.3/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "b68b059dbc716e30778661cf3a84d3dcb9d2c027b032d2cc3e34253c5e4deaef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.3/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "f416a4d7997d5e4307464f7899c0fdedd07c03fe49eb065c9f6c0a8b310a3dc9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.3/fetchira-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fea4bb0d40f3ca787108da4a1901c412b99c75693a2831e6358091e5f49433f3"
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
