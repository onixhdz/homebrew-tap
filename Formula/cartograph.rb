class Cartograph < Formula
  desc "Build a nervous system for your codebase"
  homepage "https://github.com/realxen/cartograph"
  url "https://github.com/realxen/cartograph/releases/download/v0.1.11/cartograph-darwin-arm64"
  version "0.1.11"
  sha256 "3e60aa63ba9b07fa743d7b82d491a67ff265adb1fed187c83a2bdcc1365fae36"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.11/cartograph-darwin-arm64"
      sha256 "3e60aa63ba9b07fa743d7b82d491a67ff265adb1fed187c83a2bdcc1365fae36"
    end

    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.11/cartograph-darwin-amd64"
      sha256 "c7e28421a5bcf947a59ce8f04f9d91858d46c29eff5538c479e772dcad4b2fe5"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.11/cartograph-linux-amd64"
      sha256 "d3c7ad89fa747bfb4789d0701c127c513b128dfa9f5d87df3552dafc5dfccf75"
    end

    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.11/cartograph-linux-arm64"
      sha256 "912ca0f75d931938c46ba86f0b7b25c1624ce508d5910dabea0a6c49bb19b614"
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
