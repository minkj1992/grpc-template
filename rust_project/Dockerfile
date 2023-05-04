FROM rust:1.68

WORKDIR /app

COPY . .

RUN cargo install --path .
CMD ["/app/target/release/<YOUR_BINARY_NAME>"]
