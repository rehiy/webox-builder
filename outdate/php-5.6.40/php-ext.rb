class PhpExt < Formula
    desc "General-purpose scripting language"
    homepage "https://www.php.net/"
    url "https://www.php.net/distributions/php-5.6.40.tar.xz"

    depends_on "autoconf" => :build
    depends_on "pkg-config" => :build

    depends_on "anrip/webox/openssl@1.0"
    depends_on "anrip/webox/php"
    depends_on "curl-openssl"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "gd"
    depends_on "imagemagick@6"
    depends_on "jpeg"
    depends_on "libffi"
    depends_on "libpng"
    depends_on "libzip"
    depends_on "mcrypt"
    depends_on "oniguruma"
    depends_on "re2c"
    depends_on "webp"

    uses_from_macos "xz" => :build
    uses_from_macos "bzip2"
    uses_from_macos "libxml2"
    uses_from_macos "libxslt"
    uses_from_macos "zlib"

    resource "redis" do
      url "http://pecl.php.net/get/redis-4.3.0.tgz"
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
      ENV.append_path "PKG_CONFIG_PATH", Formula["openssl@1.0"].opt_lib/"pkgconfig"

      php_ext_make "bcmath"
      php_ext_make "bz2"
      php_ext_make "calendar"
      php_ext_make "curl", "--with-curl=#{Formula["curl-openssl"].opt_prefix}"
      php_ext_make "exif"
      php_ext_make "ftp"
      php_ext_make "gd", "--with-freetype-dir=#{HOMEBREW_PREFIX}", "--with-jpeg-dir=#{HOMEBREW_PREFIX}", "--with-png-dir=#{HOMEBREW_PREFIX}", "--with-zlib-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "gettext", "--with-gettext=#{HOMEBREW_PREFIX}"
      php_ext_make "mbstring"
      php_ext_make "mcrypt", "--with-mcrypt=#{HOMEBREW_PREFIX}"
      php_ext_make "openssl", "--with-openssl-dir=#{Formula["openssl@1.0"].opt_prefix}"
      php_ext_make "pcntl"
      php_ext_make "shmop"
      php_ext_make "soap", "--with-libxml-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "sockets"
      php_ext_make "sysvmsg"
      php_ext_make "sysvsem"
      php_ext_make "sysvshm"
      php_ext_make "xmlrpc", "--with-libxml-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "xsl", "--with-xsl=#{HOMEBREW_PREFIX}"
      php_ext_make "zip", "--with-libzip=#{HOMEBREW_PREFIX}", "--with-pcre-dir=#{HOMEBREW_PREFIX}", "--with-zlib-dir=#{HOMEBREW_PREFIX}"
      php_ext_make "zlib", "--with-zlib-dir=#{HOMEBREW_PREFIX}"

      resource("redis").stage do
        mv "redis-4.3.0", buildpath/"ext/redis"
        php_ext_make "redis"
      end
    end

    def php_ext_make (ext, *args)
      if (lib/"php/20131226/#{ext}.so").exist?
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
      (lib/"php/20131226/redis.so").exist?
    end
end
