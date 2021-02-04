{ nixpkgs ? import ./nixpkgs.nix , compiler ? "default" }:

let
  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default" then
    pkgs.haskellPackages
  else
    pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callCabal2nix "meckweb" (./.) { };

  # The css renderer (Clay) needs ghc 
  # Run the Clay directly in nix, bypassing cabal
  ghcClay = haskellPackages.ghcWithPackages (p: with p; [ clay text ]);
  generator = pkgs.haskell.lib.overrideCabal drv (old: {
    postConfigure = ''
      substituteInPlace src/Site.hs --replace '"cabal" ["v2-exec", "runghc"]' '"${ghcClay}/bin/runghc" []'
    '';
  });

in generator
