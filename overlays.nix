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
    # Tempoprary fix for neovide in nixos-unstable
    neovide = prev.callPackage ./pkgs/tempfix-neovide {
      inherit (prev)
        rustPlatform
        clangStdenv
        fetchFromGitHub
        linkFarm
        fetchgit
        runCommand
        gn
        neovim
        ninja
        makeWrapper
        pkg-config
        python3
        removeReferencesTo
        apple-sdk_11
        SDL2
        fontconfig
        xorg
        stdenv
        libglvnd
        libxkbcommon
        wayland
        ;
    };
    # inherit breezex-cursor syncstorage-rs neovide;
  })
]
