#!/bin/sh
set -eu

for target in "clean" "install" ; do
  for d in fuse fuse/nodefs fuse/pathfs fuse/test zipfs unionfs \
    example/hello example/loopback example/zipfs \
    example/multizip example/unionfs example/memfs \
    example/autounionfs ; \
  do
    if test "${target}" = "install" && test "${d}" = "fuse/test"; then
      continue
    fi
    echo "go ${target} github.com/alokmenghrajani/go-fuse/${d}"
    go ${target} github.com/alokmenghrajani/go-fuse/${d}
  done
done

for d in fuse zipfs unionfs fuse/test
do
    (
        cd $d
        echo "go test github.com/alokmenghrajani/go-fuse/$d"
        go test github.com/alokmenghrajani/go-fuse/$d
        echo "go test -race github.com/alokmenghrajani/go-fuse/$d"
        go test -race github.com/alokmenghrajani/go-fuse/$d
    )
done

make -C benchmark
for d in benchmark
do
  go test github.com/alokmenghrajani/go-fuse/benchmark -test.bench '.*' -test.cpu 1,2
done
