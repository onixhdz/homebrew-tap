class Cartograph < Formula
  desc "Build a nervous system for your codebase"
  homepage "https://github.com/realxen/cartograph"
  url "https://github.com/realxen/cartograph/releases/download/v0.1.5/cartograph-darwin-arm64"
  version "0.1.5"
  sha256 "482828c64f956ea0d0c3b856c2bbf0f56b082e1f60b1e482b6a337eaf919aa97"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.5/cartograph-darwin-arm64"
      sha256 "482828c64f956ea0d0c3b856c2bbf0f56b082e1f60b1e482b6a337eaf919aa97"
    end

    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.5/cartograph-darwin-amd64"
      sha256 "1c99d5a63146355f193ba36edf8b8401d7c7f261d161ca995cf3cec4f3aa8906"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.5/cartograph-linux-amd64"
      sha256 "6f9b1f5fa77fed995a4c60304ab1d0c3bfefacb69fcbf6a8033f2c58f4fd7d57"
    end

    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.5/cartograph-linux-arm64"
      sha256 "f5bbd398ec33084f0328ebaeb628a1d67e591cf5ee4b9b9f92219ebcbd6c9a2b"
    end
  end

  def install
    binary_name =
      if OS.mac?
        Hardware::CPU.arm? ? "cartograph-darwin-arm64" : "cartograph-darwin-amd64"
      elsif OS.linux?
        Hardware::CPU.arm? ? "cartograph-linux-arm64" : "cartograph-linux-amd64"
      else
        odie "unsupported platform"
      end

    bin.install binary_name => "cartograph"
    (buildpath/"cartograph.bash").write <<~BASH
      complete -o default -o bashdefault -C #{opt_bin}/cartograph cartograph
    BASH
    bash_completion.install buildpath/"cartograph.bash" => "cartograph"
  end

  def post_install
    system bin/"cartograph", "skills", "install", "--upgrade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartograph -v")
    assert_match "complete -o default", shell_output("#{bin}/cartograph completion -c bash")
  end
end
