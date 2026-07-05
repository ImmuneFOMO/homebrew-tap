class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.4/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "370e07371e91bf8ccd4f108710919f15699dad5d9821a0cf19c8ca1200431983"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.4/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "c67b1b7633c5ab789da91334d82026fe933ffca98fbe4bfa1c807dc23492062c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.4/fetchira-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2277b124fa24fd9ca293e548c9813258b0ad80a8e84c0176b6e7f31c76a1100b"
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
