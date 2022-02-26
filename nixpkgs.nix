import
  (builtins.fetchTarball {
    name = "nixos-unstable-2021-02-04";
    url =
      "https://github.com/nixos/nixpkgs/archive/7cbec40a09533dd9c525d6ab94dddfe77768101a.tar.gz";
    sha256 = "006fns0kxs9n32cg6f4p0zyaxxsyidwsa152flpsbaky1c6drn96";
  })
{
  overlays = [

    (self: super: {
      haskellPackages = with self.haskell.lib;
        super.haskellPackages.extend (hself: hsuper: {

          hakyll = dontCheck (markUnbroken (overrideSrc hsuper.hakyll {
            src = super.fetchFromGitHub {
              owner = "jaspervdj";
              repo = "hakyll";
              rev = "f3881821328fae8cba848627f1caf2086121c903";
              sha256 = "1nhkjr1qwml3i35q8p599s6gl2rp1ppci1px1xy934h3hl4c20hv";
            };
          }));
        });
    })
  ];
}
