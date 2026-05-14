class Cartograph < Formula
  desc "Build a nervous system for your codebase"
  homepage "https://github.com/realxen/cartograph"
  url "https://github.com/realxen/cartograph/releases/download/v0.1.6/cartograph-darwin-arm64"
  version "0.1.6"
  sha256 "f896377cb0f615c15933f3d2beb0298c87c5d684af4f9eafa88bd20dd9af89a9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.6/cartograph-darwin-arm64"
      sha256 "f896377cb0f615c15933f3d2beb0298c87c5d684af4f9eafa88bd20dd9af89a9"
    end

    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.6/cartograph-darwin-amd64"
      sha256 "65f1ce39c5ec63bd1628cd0cdbce8548ed42233394f878f89b54c6ad3abe05be"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.6/cartograph-linux-amd64"
      sha256 "b38a372a804e551b8e7f3d8fd239957496992f94223764ce5bb4958fe6f69058"
    end

    if Hardware::CPU.arm?
      url "https://github.com/realxen/cartograph/releases/download/v0.1.6/cartograph-linux-arm64"
      sha256 "8caa819bc50368724fdafe0ad8ac910fa94327061f78768cb715f7bbe04fa8bf"
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
