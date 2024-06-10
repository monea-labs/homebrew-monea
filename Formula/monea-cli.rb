class MoneaCli < Formula
  desc "An unopinionated CLI for playing rollup legos."
  homepage "https://monealabs.xyz"
  version "0.1.0-alpha.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.7/monea-cli-aarch64-apple-darwin.tar.gz"
      sha256 "993984c2d6d774c9d7c54b7387cdbc3e9c4d31093095e61faefe253ae2ba5ac4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.7/monea-cli-x86_64-apple-darwin.tar.gz"
      sha256 "6ac5b26ec17424c6c9386d6da9adbc4495c72333e2e389eea5a5f704b9731a62"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.7/monea-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cb4b5f09726ba35faa81c71f8068f8c5eb3ae51cb85b9e1dd7bab7a902919251"
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
