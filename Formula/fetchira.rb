class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.8/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "2466adbbb4334198c57fdf63cbfe6b873fff272f3170dc1adc669f576b0ea5f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.8/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "c638a23f2e9be26eccb374fb61bd7de477bd5cae93b2e4bdb74bf32efe9e21af"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.8/fetchira-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "178acea1f80c6bece79b54a7b74b48565f48216eef1579cb1b3eeac11dabad6e"
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
