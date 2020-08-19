{ compiler ? "default" }:

let
  nixpkgs = import ./nixpkgs.nix;

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default" then
    pkgs.haskellPackages
  else
    pkgs.haskell.packages.${compiler};

  siteGen = nixpkgs.callPackage ./default.nix {
    nixpkgs = nixpkgs;
    compiler = compiler;
  };

in nixpkgs.stdenv.mkDerivation {
  name = "meck-website";

  ${if !nixpkgs.stdenv.isDarwin then "LOCALE_ARCHIVE" else null} =
    "${nixpkgs.glibcLocales}/lib/locale/locale-archive";
  ${if !nixpkgs.stdenv.isDarwin then "LC_ALL" else null} = "en_US.UTF-8";

  preConfigure = ''export LANG="en_US.UTF-8";'';

  src = nixpkgs.lib.cleanSource ./.;

  buildPhase = ''
    ${siteGen}/bin/site rebuild
  '';
  installPhase = ''
    mkdir -p $out
    cp -r _site/* $out/
  '';

}
