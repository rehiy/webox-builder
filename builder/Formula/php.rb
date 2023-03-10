class Php < Formula
    desc "General-purpose scripting language"
    homepage "https://www.php.net/"
    url "https://www.php.net/distributions/php-7.4.12.tar.xz"
    sha256 "e82d2bcead05255f6b7d2ff4e2561bc334204955820cabc2457b5239fde96b76"

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
      ]

      if OS.mac?
        args << "--with-iconv=#{HOMEBREW_PREFIX}"
      end

      system "./configure", *args
      system "make", "install"
    end

    test do
      system "#{sbin}/php-fpm", "-t"
    end
end
