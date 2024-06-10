class MoneaCli < Formula
  desc "An unopinionated CLI for playing rollup legos."
  homepage "https://monealabs.xyz"
  version "0.1.0-alpha.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.5/monea-cli-aarch64-apple-darwin.tar.gz"
      sha256 "a3e329effcb9167d5703d9c9a8e93b936f2c85c1afbfe1598e54777bb246618d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.5/monea-cli-x86_64-apple-darwin.tar.gz"
      sha256 "837c718bcf3e56013201de60041bc2293c01307af3f615af63b152e18e7ee70d"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/monea-labs/monea-cli/releases/download/v0.1.0-alpha.5/monea-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e2537049d85a290901ddd69676adbf84a375e0fe6d03e881b0c4d169aec36ad5"
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
