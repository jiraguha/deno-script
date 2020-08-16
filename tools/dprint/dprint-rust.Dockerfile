# Installing /usr/local/cargo/bin/dprint
FROM rust
RUN cargo install --version 0.9.0 dprint
ENTRYPOINT ["/usr/local/cargo/bin/dprint"]
CMD ["-h"]
