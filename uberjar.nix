{
  lib,
  maven,
  jre,
  makeWrapper,
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
  maven.buildMavenPackage rec {
    pname = "demo-app-quarkus";
    version = "latest";

    src = ./.;
    nativeBuildInputs = [makeWrapper];

    mvnParameters = lib.escapeShellArgs [
      "clean"
      "package"
      "-Dquarkus.package.jar.type=uber-jar"
      "-Dquarkus.console.enabled=true"
    ];
    mvnHash = "sha256-UgTlrWLgc0PemjFyKc/NSWaiVq/8scT9yIM5ze+9IJI=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin "$out/share/${pname}"
      cp -r ./target/*-runner.jar "$out/share/${pname}/${pname}-runner.jar"

      makeWrapper ${lib.getExe' jre "java"} $out/bin/${pname} \
        --add-flags "-jar $out/share/${pname}/${pname}-runner.jar"

      runHook postInstall
    '';

    meta.mainProgram = "demo-app-quarkus";
  }
