{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "geode-cli";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "geode-sdk";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-2KOea6tjkdbA5Vj/ZWmH5OgquIxlKscXnIVD7Zy3ns0=";
  };

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  cargoHash = "sha256-NAn7pO/lWTxSzzTbD0H+G+tjEY1A4hcuYZzUZE8Ojew=";
}
