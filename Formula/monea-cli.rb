class MoneaCli < Formula
  desc "An unopinionated CLI for playing rollup legos."
  homepage "https://monealabs.xyz"
  version "0.1.0-alpha.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.4/monea-cli-aarch64-apple-darwin.tar.gz"
      sha256 "c2718a9914c7e70b40fa57ce2335e434f79dcd91187f8391173d4a4720cb83ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.4/monea-cli-x86_64-apple-darwin.tar.gz"
      sha256 "a45777d114dc28511ed2fdff28ac61058cab5df96d9c1d34d48b3aa2abdcb476"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.4/monea-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aae9bde612365db196a59919e881f1a30116a5ece7c7380bd001626a60046ea5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
