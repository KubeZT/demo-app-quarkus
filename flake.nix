{
  outputs = {
    self,
    nixpkgs,
    nix2container,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
    forEachSystem = f:
      builtins.listToAttrs (map (system: {
          name = system;
          value = f system;
        })
        systems);
  in {
    packages = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      n2c = nix2container.packages."${system}".nix2container;

      uberjar = pkgs.callPackage ./uberjar.nix {};
      native = pkgs.callPackage ./native.nix {};

      native-image = n2c.buildImage {
        name = "registry.demo.kubezt.com/demo/${native.pname}";
        #name = "docker.io/ossys/demo-app-quarkus";
        tag = "native-latest";

        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          paths = [native];
          #pathsToLink = ["/bin"];
        };

        config = {
          Cmd = ["/bin/demo-app-quarkus"];
          WorkingDir = "/tmp";
        };
      };

      uberjar-image = n2c.buildImage {
        name = "registry.demo.kubezt.com/demo/demo-app-quarkus";
        tag = "uberjar-latest";

        copyToRoot = pkgs.buildEnv {
          name = "image-root";
          paths = [uberjar];
          pathsToLink = ["/bin" "/share"];
        };

        config = {
          Cmd = ["/bin/demo-app-quarkus"];
          WorkingDir = "/tmp";
        };
      };
    in rec {
      inherit uberjar native native-image uberjar-image;
      default = native;
    });
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix2container.url = "github:andrewzah/nix2container";
  };
}
