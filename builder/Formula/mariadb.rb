class Mariadb < Formula
    desc "Drop-in replacement for MySQL"
    homepage "https://mariadb.org/"
    url "https://downloads.mariadb.com/MariaDB/mariadb-10.5.6/source/mariadb-10.5.6.tar.gz"
    sha256 "ff05dd69e9f6992caf1053242db704f04eda6f9accbcc98b74edfaf6013c45c4"

    depends_on "cmake" => :build
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"

    unless OS.mac?
      depends_on "gcc@7" => :build
      depends_on "libcsv"
    end

    uses_from_macos "bison" => :build
    uses_from_macos "bzip2"
    uses_from_macos "ncurses"
    uses_from_macos "zlib"

    def install
      # Set basedir and ldata for mysql_install_db
      inreplace "scripts/mysql_install_db.sh" do |s|
        s.change_make_var! "basedir", "\"#{prefix}\""
        s.change_make_var! "ldata", "\"#{var}/mysql\""
      end

      args = %W[
        -DDEFAULT_CHARSET=utf8mb4
        -DDEFAULT_COLLATION=utf8mb4_general_ci
        -DENABLED_LOCAL_INFILE=1
        -DINSTALL_DOCDIR=share/doc/#{name}
        -DINSTALL_INCLUDEDIR=include/mysql
        -DINSTALL_INFODIR=share/info
        -DINSTALL_MANDIR=share/man
        -DINSTALL_MYSQLSHAREDIR=share/mysql
        -DINSTALL_PLUGINDIR=lib/plugin
        -DINSTALL_SBINDIR=sbin
        -DINSTALL_SYSCONFDIR=#{etc}/mysql
        -DMYSQL_DATADIR=#{var}/lib/mysql
        -DMYSQL_UNIX_ADDR=#{var}/run/mysql/mysqld.sock
        -DPLUGIN_MROONGA=NO
        -DPLUGIN_PAM=NO
        -DPLUGIN_ROCKSDB=NO
        -DPLUGIN_TOKUDB=NO
        -DWITH_NUMA=OFF
        -DWITH_PCRE=bundled
        -DWITH_READLINE=yes
        -DWITH_SSL=yes
        -DWITH_UNIT_TESTS=OFF
      ]

      system "cmake", ".", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end

    def post_install
      system "rm -rf #{bin}/*embedded"
      system "rm -rf #{bin}/*test"
      system "rm -rf #{lib}/plugin/*test*"
      system "rm -rf #{lib}/plugin/*example*"
      system "rm -rf #{prefix}/support-files"
      system "rm -rf #{prefix}/sql-bench"
      system "rm -rf #{prefix}/*-test"
      system "rm -rf #{prefix}/data"
      system "rm -rf #{prefix}/COPYING"
      system "rm -rf #{prefix}/CREDITS"
      system "rm -rf #{prefix}/EXCEPTIONS-CLIENT"
      system "rm -rf #{prefix}/INSTALL*"
      system "rm -rf #{prefix}/README*"
      system "rm -rf #{prefix}/THIRDPARTY"
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
      system sbin/"mysqld", "--version"
    end
end
