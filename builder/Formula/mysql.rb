class Mysql < Formula
    desc "Open source relational database management system"
    homepage "https://dev.mysql.com/doc/refman/5.7/en/"
    url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.31.tar.gz"
    sha256 "85bd222e61846313d7ad7c095ad664c89ca8f52dd9c21b7ac343ead62d701200"

    depends_on "cmake" => :build
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"

    uses_from_macos "libedit"

    def install
      ENV.append_to_cflags "-fPIC" unless OS.mac?

      args = %W[
        -DDEFAULT_CHARSET=utf8mb4
        -DDEFAULT_COLLATION=utf8mb4_general_ci
        -DENABLED_LOCAL_INFILE=1
        -DINSTALL_DOCDIR=share/doc/mysql
        -DINSTALL_INCLUDEDIR=include/mysql
        -DINSTALL_INFODIR=share/info
        -DINSTALL_MANDIR=share/man
        -DINSTALL_MYSQLSHAREDIR=share/mysql
        -DINSTALL_PLUGINDIR=lib/plugin
        -DINSTALL_SBINDIR=sbin
        -DMYSQL_DATADIR=#{var}/lib/mysql
        -DMYSQL_UNIX_ADDR=#{var}/run/mysql/mysqld.sock
        -DSYSCONFDIR=#{etc}/mysql
        -DWITH_BOOST=boost
        -DWITH_EDITLINE=system
        -DWITH_SSL=yes
        -DWITH_UNIT_TESTS=OFF
        -DWITH_EMBEDDED_SERVER=OFF
        -DWITH_INNODB_MEMCACHED=ON
      ]

      system "cmake", ".", *std_cmake_args, *args
      system "make"
      system "make", "install"

      (prefix/"mysql-test").cd do
        system "./mysql-test-run.pl", "status", "--vardir=#{Dir.mktmpdir}"
      end
    end

    def post_install
      system "rm -rf #{bin}/mysql_install_db"
      system "rm -rf #{bin}/*embedded"
      system "rm -rf #{bin}/*test"
      system "rm -rf #{lib}/plugin/*test*"
      system "rm -rf #{lib}/plugin/*example*"
      system "rm -rf #{prefix}/support-files"
      system "rm -rf #{prefix}/*-test"
      system "rm -rf #{prefix}/data"
    end

    plist_options manual: "mysqld_safe"

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
            <string>#{opt_bin}/mysqld_safe</string>
            <string>--datadir=#{var}/lib/mysql</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}/lib/mysql</string>
        </dict>
        </plist>
      EOS
    end

    test do
      dir = Dir.mktmpdir
      system sbin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{dir}", "--tmpdir=#{dir}"

      port = free_port
      pid = fork do
        exec sbin/"mysqld", "--bind-address=127.0.0.1", "--datadir=#{dir}", "--port=#{port}"
      end
      sleep 2

      output = shell_output("curl 127.0.0.1:#{port}")
      output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
      assert_match version.to_s, output
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
end
