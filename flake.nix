{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, flake-utils, naersk, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        #pkgBuildInputs = with pkgs; [
        #  openssl
        #];

        #pkgNativeBuildInputs = with pkgs; [
        #  pkg-config
        #];

        naersk' = pkgs.callPackage naersk {};
        
      in rec {
        defaultPackage = naersk'.buildPackage {
          src = ./.;

          #nativeBuildInputs = pkgNativeBuildInputs;

          #buildInputs = pkgBuildInputs;
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rustc
            cargo
            rustfmt
            nixpkgs-fmt
            sccache
            clippy
            rust-analyzer
            bazel
            bazel-watcher
          ];
          #++ pkgNativeBuildInputs;

          RUSTC_WRAPPER = "sccache";
          RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

          #buildInputs = pkgBuildInputs;
        };
      }
    );
}
