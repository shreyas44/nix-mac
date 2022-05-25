{ pkgs ? import <nixpkgs> { } }:
let script = image: ''
  dir=$(pwd)
  container=$(docker run -itd -v $dir:/app ${image} "sleep infinity")
  docker exec -it $container "$@"

  result=$(docker exec $container readlink /app/result)
  rm -rf ./result
  docker cp $container:$result ./result
  docker kill $container
''; in
[
  (pkgs.writeShellScriptBin "nix-intel" (script "shreyas4/nix-unstable"))
  (pkgs.writeShellScriptBin "nix-flakes-intel" (script "shreyas4/nix-flakes"))
]
