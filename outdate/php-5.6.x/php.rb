class Php < Formula
    desc "General-purpose scripting language"
    homepage "https://www.php.net/"
    url "https://www.php.net/distributions/php-5.6.40.tar.xz"
    sha256 "1369a51eee3995d7fbd1c5342e5cc917760e276d561595b6052b21ace2656d1c"

    depends_on "autoconf" => :build
    depends_on "pkg-config" => :build

    depends_on "anrip/webox/openssl@1.0"
    depends_on "glib"
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
