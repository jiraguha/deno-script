# Installing /usr/local/cargo/bin/dprint
FROM ubuntu:bionic
RUN   apt-get update && \
      # install utilities
      apt-get install -y \
        curl \
        zip \
        bzip2 && \
        cd $HOME && \
        curl -LO https://github.com/dprint/dprint/releases/download/0.9.0/dprint-x86_64-unknown-linux-gnu.zip && \
        unzip dprint-x86_64-unknown-linux-gnu.zip && rm dprint-x86_64-unknown-linux-gnu.zip && \
        mv dprint  /usr/local/bin

ENTRYPOINT ["/usr/local/bin/dprint"]
CMD ["-h"]
