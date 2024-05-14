{
  description = "A Go 1.22 development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Use flake-utils to simplify flake setup across multiple systems
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Import the nixpkgs with overlay and configuration
        pkgs = import nixpkgs {
          inherit system;
          overlays = [];
        };
        in {
          # Define a development shell
          devShell = pkgs.mkShell {
            buildInputs = [
              pkgs.go_1_22
              pkgs.gopls
            ];

            # Optional: Set GOPATH and other env variables
          };
        }
    );
}
