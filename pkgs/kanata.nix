{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = "kanata";
    rev = "refs/tags/v${version}";
    hash = "sha256-cG9so0x0y8CbTxLOxSQwn5vG72KxHJzzTIH4lQA4MvE=";
  };

  cargoHash = "sha256-9C+oa+J5mcQzzcopAX+OZXymXmTsZPBXGTH2cpvvVKI=";

  meta = {
    description = "Improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
    mainProgram = "kanata";
  };
}
