class Cartograph < Formula
  desc "Build a nervous system for your codebase"
  homepage "https://github.com/realxen/cartograph"
  url "https://github.com/realxen/cartograph/releases/download/v0.1.10/cartograph-darwin-arm64"
  version "0.1.10"
  sha256 "3c036655843c3ed11650c7495f22657f466cd4ce061024a69aefae3cfcb69a9d"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.10/cartograph-darwin-arm64"
      sha256 "3c036655843c3ed11650c7495f22657f466cd4ce061024a69aefae3cfcb69a9d"
    end

    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.10/cartograph-darwin-amd64"
      sha256 "315cf1b3c975709de8d37ec010f84225035b3a70aa7efcda052729cd5d3ecbce"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.10/cartograph-linux-amd64"
      sha256 "81cf46011cf7aa0704f76ddfadd9c1713d926d5d89aea0d7bb58d8ef755ffaec"
    end

    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.10/cartograph-linux-arm64"
      sha256 "efd29cbc05134d3b036191440fad0e12eaed0e94bc44834cceb85a5852ad130a"
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
