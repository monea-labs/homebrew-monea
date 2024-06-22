class MoneaCli < Formula
  desc "An unopinionated CLI for playing rollup legos."
  homepage "https://monealabs.xyz"
  version "0.1.0-alpha.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/monea-xyz/monea-cli/releases/download/v0.1.0-alpha.8/monea-cli-aarch64-apple-darwin.tar.gz"
      sha256 "c6c16d58454b88ebc19b2ee2919aee2d0913e4531dfb7604b40606e3a0ac8171"
    end
    if Hardware::CPU.intel?
      url "https://github.com/monea-xyz/monea-cli/releases/download/v0.1.0-alpha.8/monea-cli-x86_64-apple-darwin.tar.gz"
      sha256 "b52c3842e4c7d7a497e06f2ee63c251d8077244c17c9102d4519c1b7e68c238f"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/monea-xyz/monea-cli/releases/download/v0.1.0-alpha.8/monea-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "faa0a87114317ada08b4ca6e783c792953f43d26b6f66b1f2aea296d1317ff43"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {"monea-cli": ["monea"]}, "x86_64-apple-darwin": {"monea-cli": ["monea"]}, "x86_64-pc-windows-gnu": {"monea-cli.exe": ["monea.exe"]}, "x86_64-unknown-linux-gnu": {"monea-cli": ["monea"]}}

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
      bin.install "monea-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "monea-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "monea-cli"
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
