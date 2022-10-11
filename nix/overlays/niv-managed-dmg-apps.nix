{
  nivSources,
  hdiutil,
}: self: super: let
  inherit (self) stdenvNoCC lib;
  inherit (lib) isAttrs mapAttrs filterAttrs hasInfix;
  nivManagedDmgs = filterAttrs (n: v: (isAttrs v) && (hasInfix ".dmg" v.url)) nivSources;
  dmgInstall = args:
    stdenvNoCC.mkDerivation (args
      // {
        sourceRoot = ".";
        preferLocalBuild = true;
        phases = ["installPhase"];
        installPhase = ''
          mkdir -p mnt $out/Applications
          ${hdiutil} attach -readonly -mountpoint mnt $src
          cp -r mnt/*.app $out/Applications/
          ${hdiutil} detach -force mnt
        '';
      });
  dmgPkgs = mapAttrs (n: v:
    dmgInstall {
      src = v;
      name = n;
      version = v.version;
    })
  nivManagedDmgs;
in {
  nivApps = dmgPkgs;
}
