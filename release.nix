{ }:
let
  nixpkgs = import ./nix/nixpkgs {};
  inherit (nixpkgs) lib;
  inherit (nixpkgs.haskell.lib) doJailbreak dontCheck markUnbroken overrideCabal;
  filteredSource = builtins.fetchGit ./.;
in
  nixpkgs.haskell.packages.ghc965.callCabal2nix "jsdom-extras" filteredSource {}

