{ pkgs ? import <nixpkgs> {} }:

let
  hs-build-tools = (
    with pkgs.haskellPackages; [ cabal2nix
                                 stylish-haskell
                               ]);
in

pkgs.mkShell {
  nativeBuildInputs = hs-build-tools;
}
