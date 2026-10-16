class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.17/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "f636a605b0e563aa2eaace94bab903f247b8917c3aea4552d39edf2951a2fe7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.17/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "f62727134086e19c03879179b4ebaaab70d32dd1337a1b973fb042c9a0ba2854"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.17/fetchira-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "53de8cef029e3d2c47f6eae93f374bfebfbffe24f7f47e1a14ad75f4e9b0f397"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.17/fetchira-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b691c5524da0c6ba2f5259524fac8112c6a68fd952b17a5853d4d9562707cef3"
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
