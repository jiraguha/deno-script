#!/bin/bash
bats_version=1.2.1
deno_version=1.2.2

docker build -t jpiraguha/deno-bats:deno-1.2.2_bats-1.2.1 . \
 --build-arg bats_version=$bats_version \
 --build-arg deno_version=$deno_version && \
docker push jpiraguha/deno-bats:deno-${deno_version}_bats-${bats_version}
