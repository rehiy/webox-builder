class Php < Formula
    desc "General-purpose scripting language"
    homepage "https://www.php.net/"
    url "https://www.php.net/distributions/php-7.3.20.tar.xz"
    sha256 "43292046f6684eb13acb637276d4aa1dd9f66b0b7045e6f1493bc90db389b888"

    depends_on "autoconf" => :build
    depends_on "pkg-config" => :build

    depends_on "glib"
    depends_on "openssl@1.1"
    depends_on "sqlite"

    uses_from_macos "xz" => :build
    uses_from_macos "libxml2"
    uses_from_macos "zlib"

    def install
      config_path = etc/"php"

      args = %W[
        --prefix=#{prefix}
        --localstatedir=#{var}
        --sysconfdir=#{config_path}
        --with-config-file-path=#{config_path}
        --with-config-file-scan-dir=#{config_path}/php.d
        --with-layout=GNU
        --without-pear
        --disable-rpath
        --disable-cgi
        --enable-fpm
        --with-mysqli
        --with-pdo-mysql
        --with-libxml-dir=#{HOMEBREW_PREFIX}
      ]

      system "./configure", *args
      system "make", "install"
    end

    def php_version
      version.to_s.split(".")[0..1].join(".")
    end

    test do
      system "#{sbin}/php-fpm", "-t"
    end
end
