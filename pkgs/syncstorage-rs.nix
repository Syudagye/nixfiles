{ fetchFromGitHub
, rustPlatform
, pkg-config
, python3
, cmake
, libmysqlclient
, makeBinaryWrapper
, lib
}:

let
  pyFxADeps = python3.withPackages (p: [
    p.setuptools # imports pkg_resources
    # remainder taken from requirements.txt
    p.pyfxa
    p.tokenlib
    p.cryptography
  ]);
  pname = "syncstorage-rs";
  version = "0.14.4";
  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Q9r8a+PTb3GMH50d/e2fKoG67zVhtW1kx4QA7Pj82Sw=";
  };

in

rustPlatform.buildRustPackage rec {
  inherit pname version src;

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    libmysqlclient
  ];

  preFixup = ''
    wrapProgram $out/bin/syncserver \
      --prefix PATH : ${lib.makeBinPath [ pyFxADeps ]}
  '';

  cargoLock = {
    lockFile = src.outPath + "/Cargo.lock";
    outputHashes = {
      "deadpool-0.5.2" = "sha256-V3v03t8XWA6rA8RaNunq2kh2U+6Lc2C2moKdaF2bmEc=";
    };
  };

  # almost all tests need a DB to test against
  doCheck = false;

  meta = {
    description = "Mozilla Sync Storage built with Rust";
    homepage = "https://github.com/mozilla-services/syncstorage-rs";
    changelog = "https://github.com/mozilla-services/syncstorage-rs/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pennae ];
    platforms = lib.platforms.linux;
    mainProgram = "syncserver";
  };
}
