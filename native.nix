{
  pkgs,
  lib,
  maven,
  ...
}: let
  fs = lib.fileset;
  sourceFiles = fs.difference ./. (fs.unions [
    (fs.maybeMissing ./result)
    ./flake.lock
    ./flake.nix
    ./native.nix
    ./uberjar.nix
  ]);
in
  maven.buildMavenPackage {
    pname = "demo-app-quarkus";
    version = "latest";

    src = fs.toSource {
      root = ./.;
      fileset = sourceFiles;
    };

    nativeBuildInputs = [
      pkgs.graalvmPackages.graalvm-ce
    ];


    #mvnJdk = pkgs.graalvmPackages.graalvm-ce;
    mvnParameters = lib.escapeShellArgs [
      "clean"
      "package"
      "-Dnative"
      "-Dquarkus.console.enabled=true"
    ];
    mvnHash = "sha256-UgTlrWLgc0PemjFyKc/NSWaiVq/8scT9yIM5ze+9IJI=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp ./target/demo-app-quarkus-*-runner $out/bin/demo-app-quarkus

      runHook postInstall
    '';

    meta.mainProgram = "demo-app-quarkus";
  }
# pkgs.stdenv.mkDerivation {
#   pname = "demo-app-quarkus";
#   version = "latest";
#
#   src = binary;
#   installPhase = ''
#     mkdir $out/bin
#     cp "${binary}/bin/* $out/bin/*
#   '';
# }

