let
  pkgs = import ./nix/nixpkgs {};
in
  pkgs.mkShell {
    name = "jsdom-extras";
    buildInputs = [
      pkgs.cabal-install
      pkgs.ghcid
    ];
    inputsFrom = [
      (import ./release.nix {}).env
    ];
  }

