class PhpExt < Formula
    desc "General-purpose scripting language"
    homepage "https://www.php.net/"
    url "https://www.php.net/distributions/php-7.3.20.tar.xz"
    sha256 "43292046f6684eb13acb637276d4aa1dd9f66b0b7045e6f1493bc90db389b888"

    depends_on "autoconf" => :build
    depends_on "pkg-config" => :build

    depends_on "anrip/webox/php"
    depends_on "curl-openssl"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "gd"
    depends_on "imagemagick@6"
    depends_on "jpeg"
    depends_on "libffi"
    depends_on "libmaxminddb"
    depends_on "libpng"
    depends_on "libzip"
    depends_on "oniguruma"
    depends_on "openssl@1.1"
    depends_on "re2c"
    depends_on "webp"

    uses_from_macos "xz" => :build
    uses_from_macos "bzip2"
    uses_from_macos "libxml2"
    uses_from_macos "libxslt"
    uses_from_macos "zlib"

    resource "redis" do
      url "http://pecl.php.net/get/redis-5.2.2.tgz"
    end

    resource "swoole" do
      url "http://pecl.php.net/get/swoole-4.5.2.tgz"
    end

    resource "imagick" do
      url "http://pecl.php.net/get/imagick-3.4.4.tgz"
    end

    resource "maxminddb" do
      url "https://codeload.github.com/maxmind/MaxMind-DB-Reader-php/zip/master"
    end

    def install
      @log = prefix/"install.log"
      @log.write ">> start\n"

      # Link lib to php/lib
      unless lib.exist?
        system "ln -s ../../php/#{version}/lib #{prefix}/"
      end

      # Prevent homebrew from harcoding path to sed shim in phpize script
      ENV["lt_cv_path_SED"] = "sed"

      # system pkg-config missing
      ENV["BZIP_DIR"] = Formula["bzip2"].opt_prefix

      php_ext_make "bcmath"
      php_ext_make "bz2"
      php_ext_make "calendar"
      php_ext_make "curl"
      php_ext_make "exif"
      php_ext_make "ftp", "--with-openssl-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "gd", "--with-freetype-dir=#{HOMEBREW_PREFIX}", "--with-jpeg-dir=#{HOMEBREW_PREFIX}", "--with-png-dir=#{HOMEBREW_PREFIX}", "--with-zlib-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "gettext", "--with-gettext=#{HOMEBREW_PREFIX}"
      php_ext_make "mbstring"
      php_ext_make "openssl"
      php_ext_make "pcntl"
      php_ext_make "shmop"
      php_ext_make "soap"
      php_ext_make "sockets"
      php_ext_make "sysvmsg"
      php_ext_make "sysvsem"
      php_ext_make "sysvshm"
      php_ext_make "xmlrpc", "--with-libxml-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "xsl", "--with-xsl=#{HOMEBREW_PREFIX}"
      php_ext_make "zip", "--with-libzip=#{HOMEBREW_PREFIX}", "--with-pcre-dir=#{HOMEBREW_PREFIX}", "--with-zlib-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "zlib", "--with-zlib-dir=#{HOMEBREW_PREFIX}"

      resource("redis").stage do
        mv "redis-5.2.2", buildpath/"ext/redis"
        php_ext_make "redis"
      end

      resource("swoole").stage do
        mv "swoole-4.5.2", buildpath/"ext/swoole"
        php_ext_make "swoole"
      end

      resource("imagick").stage do
        mv "imagick-3.4.4", buildpath/"ext/imagick"
        php_ext_make "imagick"
      end

      resource("maxminddb").stage do
        mv "ext", buildpath/"ext/maxminddb"
        php_ext_make "maxminddb"
      end
    end

    def php_ext_make (ext, *args)
      if (lib/"php/20180731/#{ext}.so").exist?
        @log.append_lines "#{ext} exist"
        return true
      end

      @log.append_lines "#{ext} build"
      puts ">> buiding php extension: #{ext}"

      cd buildpath/"ext/#{ext}" do
        system "[ -e config.m4 ] || ln -s config0.m4 config.m4"
        system "phpize && ./configure #{args.join(' ')}"
        system "make", "install"
      end
    end

    def php_version
      version.to_s.split(".")[0..1].join(".")
    end

    test do
      (lib/"php/20180731/maxminddb.so").exist?
    end
end
