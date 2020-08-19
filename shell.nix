{ compiler ? "default" }:

let
  nixpkgs = import ./nixpkgs.nix;

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default" then
    pkgs.haskellPackages
  else
    pkgs.haskell.packages.${compiler};


  drv = pkgs.callPackage ./default.nix { compiler = compiler; };

in haskellPackages.shellFor {
  packages = pkgs: [ drv ];
  withHoogle = true;
  nativeBuildInputs = with haskellPackages; [ drv haskell-language-server cabal-install];
}
