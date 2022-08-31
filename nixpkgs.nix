import
  (builtins.fetchTarball {
    name = "nixos-unstable-2022-08-31";
    url =
      "https://github.com/nixos/nixpkgs/archive/a63021a330d8d33d862a8e29924b42d73037dd37.tar.gz";
    sha256 = "sha256:1bc1vr5k5wswd15xc5zy4bpprand9qb8rkd3c50acy3nl34ld4q0";
  })
{
  overlays = [

    (self: super: {
      haskellPackages = with self.haskell.lib;
        super.haskellPackages.extend (hself: hsuper: { });
    })
  ];
}
