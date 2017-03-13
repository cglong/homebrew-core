require "language/node"

class Gulp < Formula
  desc "Streaming build system"
  homepage "https://gulpjs.com/"
  url "https://registry.npmjs.org/gulp-cli/-/gulp-cli-1.2.2.tgz"
  sha256 "ee7974f5535f300cb1dec573bd33496cdb0667e65eca1b7bb5c382bcaef0861d"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "touch", "src/test.js"

    (testpath/"package.json").write <<-EOS.undent
    {
      "name": "gulp-homebrew-test",
      "version": "1.0.0",
      "devDependencies": {
        "gulp": "*"
      }
    }
    EOS

    (testpath/"gulpfile.js").write <<-EOS.undent
    var gulp = require("gulp");

    gulp.task("test", function() {
      return gulp.src("src/*.js")
        .pipe(gulp.dest("build"))
    });
    EOS

    system "npm", "install", *Language::Node.local_npm_install_args
    system bin/"gulp"
    assert File.exist?("build/test.js"), "test.js was not copied"
  end
end
