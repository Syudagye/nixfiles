{ pkgs, ... }:
let
  clickgen = pkgs.callPackage ./pkgs/clickgen.nix {
    inherit (pkgs.python3Packages) buildPythonPackage pythonOlder pytestCheckHook pillow python toml numpy attrs pyyaml;
    inherit (pkgs.xorg) libXcursor libX11;
  };
  breezex-cursor = pkgs.callPackage ./pkgs/breezex-cursor {
    inherit clickgen;
  };
  syncstorage-rs = pkgs.callPackage ./pkgs/syncstorage-rs.nix { };
  overlays = [
    (self: super: {
      inherit breezex-cursor;
    })
  ];
in
[
  (self: super: {
    inherit breezex-cursor syncstorage-rs;
  })
]
