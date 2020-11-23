class Redis < Formula
    desc "Persistent key-value database, with built-in net interface"
    homepage "https://redis.io/"
    url "https://download.redis.io/releases/redis-6.0.9.tar.gz"
    sha256 "dc2bdcf81c620e9f09cfd12e85d3bc631c897b2db7a55218fd8a65eaa37f86dd"

    depends_on "openssl@1.1"

    def install
      system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"
    end

    test do
      system bin/"redis-server", "--test-memory", "2"
      %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
    end
end
