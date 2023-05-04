#!/bin/bash

# curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# 프로젝트명을 변수로 정의
PYTHON_PROJECT_NAME="python_project"
RUST_PROJECT_NAME="rust_project"

# 새로운 프로젝트 생성 및 Python 버전 설정
poetry new "$PYTHON_PROJECT_NAME" && cd "$PYTHON_PROJECT_NAME"
poetry env use 3.9

# grpc 의존성 설치
poetry add grpcio grpcio-tools

# 의존성 설치
poetry install

cat << EOF > Dockerfile
FROM python:3.9

RUN apt-get update && apt-get install -y \\
    build-essential \\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pyproject.toml poetry.lock /app/

RUN pip install poetry
RUN poetry config virtualenvs.create false && poetry install --no-dev

COPY . /app

CMD ["python", "main.py"]
EOF

cd ..

# Rust 프로젝트 디렉토리 생성 및 Rust 프로젝트 생성
cargo init --bin "$RUST_PROJECT_NAME"
cd "$RUST_PROJECT_NAME"
cargo add protobuf grpcio grpcio-compiler

cat > Dockerfile << EOF
FROM rust:1.68

WORKDIR /app

COPY . .

RUN cargo install --path .
CMD ["/app/target/release/<YOUR_BINARY_NAME>"]
EOF


cd ..

