class Nginx < Formula
    desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server"
    homepage "https://nginx.org/"
    url "https://nginx.org/download/nginx-1.19.4.tar.gz"
    sha256 "61df546927905a0d624f9396bb7a8bc7ca7fd26522ce9714d56a78b73284000e"

    depends_on "libgd"
    depends_on "libmaxminddb"
    depends_on "openssl@1.1"
    depends_on "pcre"

    uses_from_macos "xz" => :build

    resource "njs" do
      url "http://hg.nginx.org/njs/archive/tip.tar.gz"
    end

    resource "http_geoip2" do
      url "https://codeload.github.com/leev/ngx_http_geoip2_module/zip/master"
    end

    def install
      openssl = Formula["openssl@1.1"]
      pcre = Formula["pcre"]

      cc_opt = "-I#{pcre.opt_include} -I#{openssl.opt_include}"
      ld_opt = "-L#{pcre.opt_lib} -L#{openssl.opt_lib}"

      args = %W[
        --prefix=#{prefix}
        --sbin-path=#{sbin}/nginx
        --modules-path=#{lib}/nginx
        --conf-path=#{etc}/nginx/nginx.conf
        --pid-path=#{var}/run/nginx/nginx.pid
        --lock-path=#{var}/run/nginx/nginx.lock
        --http-client-body-temp-path=#{var}/tmp/nginx/client_body
        --http-proxy-temp-path=#{var}/tmp/nginx/proxy
        --http-fastcgi-temp-path=#{var}/tmp/nginx/fastcgi
        --http-scgi-temp-path=#{var}/tmp/nginx/scgi
        --http-uwsgi-temp-path=#{var}/tmp/nginx/uwsgi
        --http-log-path=#{var}/log/nginx/access.log
        --error-log-path=#{var}/log/nginx/error.log
        --with-cc-opt=#{cc_opt}
        --with-ld-opt=#{ld_opt}
        --with-compat
        --with-http_addition_module
        --with-http_degradation_module
        --with-http_gzip_static_module
        --with-http_image_filter_module=dynamic
        --with-http_realip_module
        --with-http_secure_link_module
        --with-http_slice_module
        --with-http_ssl_module
        --with-http_stub_status_module
        --with-http_sub_module
        --with-http_v2_module
        --with-pcre
        --with-pcre-jit
        --with-stream=dynamic
        --with-stream_realip_module
        --with-stream_ssl_module
        --with-stream_ssl_preread_module
      ]

      unless OS.mac?
        args << "--with-file-aio"
        args << "--with-threads"
      end

      resource("njs").stage buildpath/"njs"
      args << "--add-dynamic-module=njs/nginx"

      resource("http_geoip2").stage buildpath/"http_geoip2"
      args << "--add-dynamic-module=http_geoip2"

      system "./configure", *args
      system "make", "install"
    end

    def post_install
      rm_rf prefix/"html"
    end

    test do
      system sbin/"nginx", "-t"
    end
  end
