class Mysql < Formula
    desc "Open source relational database management system"
    homepage "https://dev.mysql.com/doc/refman/8.0/en/"
    url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.22.tar.gz"
    sha256 "ba765f74367c638d7cd1c546c05c14382fd997669bcd9680278e907f8d7eb484"

    depends_on "cmake" => :build
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"

    uses_from_macos "libedit"

    def install
      ENV.append_to_cflags "-fPIC" unless OS.mac?

      args = %W[
        -DFORCE_INSOURCE_BUILD=ON
        -DINSTALL_DOCDIR=share/doc/mysql
        -DINSTALL_INCLUDEDIR=include/mysql
        -DINSTALL_INFODIR=share/info
        -DINSTALL_MANDIR=share/man
        -DINSTALL_MYSQLSHAREDIR=share/mysql
        -DINSTALL_PLUGINDIR=lib/plugin
        -DINSTALL_SBINDIR=sbin
        -DMYSQL_DATADIR=#{var}/lib/mysql
        -DMYSQL_UNIX_ADDR=#{var}/run/mysql.sock
        -DSYSCONFDIR=#{etc}/mysql
        -DSYSTEMD_PID_DIR=#{var}/run/mysql
        -DTMPDIR=#{var}/tmp/mysql
        -DENABLED_LOCAL_INFILE=ON
        -DWITH_BOOST=boost
        -DWITH_EDITLINE=system
        -DWITH_SSL=#{Formula["openssl@1.1"].opt_prefix}
        -DWITH_PROTOBUF=OFF
        -DWITH_UNIT_TESTS=OFF
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
      system "rm -rf #{lib}/plugin/*example*"
      system "rm -rf #{lib}/plugin/*test*"
      system "rm -rf #{prefix}/support-files"
      system "rm -rf #{prefix}/*-test"
      system "rm -rf #{prefix}/data"
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
