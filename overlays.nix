[
  (final: prev: rec {
    clickgen = prev.callPackage ./pkgs/clickgen.nix {
      inherit (prev.python3Packages)
        buildPythonPackage
        pythonOlder
        pytestCheckHook
        pillow
        python
        toml
        numpy
        attrs
        pyyaml
        ;
      inherit (prev.xorg) libXcursor libX11;
    };
    breezex-cursor = prev.callPackage ./pkgs/breezex-cursor {
      inherit clickgen;
    };
    syncstorage-rs = prev.callPackage ./pkgs/syncstorage-rs.nix {
      inherit (prev)
        fetchFromGitHub
        rustPlatform
        pkg-config
        python3
        cmake
        libmysqlclient
        makeBinaryWrapper
        ;
    };
    createDir = prev.callPackage ./pkgs/utils/createDir.nix { };
    kanata = prev.callPackage ./pkgs/kanata.nix {
      inherit (prev) fetchFromGitHub rustPlatform;
    };
    geode-cli = prev.callPackage ./pkgs/geode-cli.nix {
      inherit (prev)
        fetchFromGitHub
        rustPlatform
        pkg-config
        openssl
        ;
    };
  })
]
