class Php < Formula
    desc "General-purpose scripting language"
    homepage "https://www.php.net/"
    url "https://www.php.net/distributions/php-7.4.11.tar.xz"
    sha256 "5408f255243bd2292f3fbc2fafc27a2ec083fcd852902728f2ba9a3ea616b8c5"

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

    def php_version
      version.to_s.split(".")[0..1].join(".")
    end

    plist_options manual: "php-fpm"

    def plist
      <<~EOS
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>KeepAlive</key>
            <true/>
            <key>Label</key>
            <string>#{plist_name}</string>
            <key>ProgramArguments</key>
            <array>
              <string>#{opt_sbin}/php-fpm</string>
              <string>--nodaemonize</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>WorkingDirectory</key>
            <string>#{var}</string>
            <key>StandardErrorPath</key>
            <string>#{var}/log/php/fpm.log</string>
          </dict>
        </plist>
      EOS
    end

    test do
      system "#{sbin}/php-fpm", "-t"
    end
end
