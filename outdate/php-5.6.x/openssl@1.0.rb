class OpensslAT10 < Formula
    desc "Cryptography and SSL/TLS Toolkit"
    homepage "https://openssl.org/"
    url "http://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz"

    keg_only :versioned_formula

    def openssldir
      etc/"openssl@1.0"
    end

    def install
      args = %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      shared
      ]

      system "./config", *args

      system "make"
      system "make", "install"
    end

    def postinstall
      # fix zero byte - libcrypto.so
      system "cd #{prefix}/lib && ar -x libcrypto.a && gcc -shared *.o -o libcrypto.so && rm *.o"
    end
end
