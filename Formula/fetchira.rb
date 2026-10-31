class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.20"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.20/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "bc4030314cb6c845ebee91421daafce5c3197df8b9919078faef23a2c950dc33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.20/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "bfc84ec928130832ec7bb67faa243f08872914aa60e6c41220759eb1629d31ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.20/fetchira-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c14cf2a97c8cdfe4b301cbabc2d513e6e96a1d7399bfb4c2d0f72449ec8cb671"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.20/fetchira-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddc91f5451b397c762973f4595d2259c625857a8c950c45c6d0849e3a3544e31"
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
