class Fetchira < Formula
  desc "Quota-aware web-search/scrape MCP server and CLI that routes across free provider tiers"
  homepage "https://github.com/ImmuneFOMO/fetchira"
  version "0.1.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.18/fetchira-aarch64-apple-darwin.tar.xz"
      sha256 "55ed23da52cea5671952aace1ee0dfd5206f0ee7ef9a7e459acfafb724dc3f5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.18/fetchira-x86_64-apple-darwin.tar.xz"
      sha256 "03f74e87e71412d9878427febb3d66de0cfa5f78dd7f2e9294e7edf5cb5c9de0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.18/fetchira-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f0d0b23876510e7583512267473bc2c32cc39c53494d1eed30794663139d47bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ImmuneFOMO/fetchira/releases/download/v0.1.18/fetchira-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3add666acc343bc932ba89f476f5a83104339f00032326cef98265434dd5571a"
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
