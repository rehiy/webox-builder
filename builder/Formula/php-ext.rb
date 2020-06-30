class PhpExt < Formula
    desc "General-purpose scripting language"
    homepage "https://www.php.net/"
    url "https://www.php.net/distributions/php-7.4.7.tar.xz"
    sha256 "53558f8f24cd8ab6fa0ea252ca8198e2650160649681ce5230c1df1dc2b52faf"

    depends_on "autoconf" => :build
    depends_on "pkg-config" => :build
    depends_on "unzip" => :build

    depends_on "anrip/webox/php"
    depends_on "curl-openssl"
    depends_on "gettext"
    depends_on "freetype"
    depends_on "imagemagick"
    depends_on "jpeg"
    depends_on "libffi"
    depends_on "libgd"
    depends_on "libmaxminddb"
    depends_on "libpng"
    depends_on "libzip"
    depends_on "oniguruma"
    depends_on "openssl@1.1"
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
      php_ext_inst
    end

    def php_ext_inst
      @name = "php"

      # Prevent homebrew from harcoding path to sed shim in phpize script
      ENV["lt_cv_path_SED"] = "sed"

      # system pkg-config missing
      ENV["BZIP_DIR"] = Formula["bzip2"].opt_prefix

      php_ext_make "bcmath"
      php_ext_make "bz2"
      php_ext_make "calendar"
      php_ext_make "curl"
      php_ext_make "exif"
      php_ext_make "ftp", "--with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
      php_ext_make "gd", "--with-freetype", "--with-jpeg", "--with-webp"
      php_ext_make "gettext"
      php_ext_make "mbstring"
      php_ext_make "openssl"
      php_ext_make "pcntl"
      php_ext_make "shmop"
      php_ext_make "soap"
      php_ext_make "sockets"
      php_ext_make "sysvmsg"
      php_ext_make "sysvsem"
      php_ext_make "sysvshm"
      php_ext_make "xsl"
      php_ext_make "xmlrpc"
      php_ext_make "zip"
      php_ext_make "zlib"

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
      if (lib/"php/20190902/#{ext}.so").exist?
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
      (lib/"php/20190902/maxminddb.so").exist?
    end
end