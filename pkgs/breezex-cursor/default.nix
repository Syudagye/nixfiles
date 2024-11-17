{
  lib,
  stdenv,
  fetchFromGitHub,
  clickgen,
  mkYarnPackage,
}:

let
  pname = "BreezeX_Cursor";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cg5mgm8n4b3g810wmziwivkyglyfsfrzydpqmw1z1p758jp6sib";
  };
in

mkYarnPackage rec {
  inherit src pname version;
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  doDist = false;

  depsBuildBuild = [
    clickgen
  ];

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  preInstall = ''
    outdir="$out/share/icons"
    mkdir -p "$outdir"

    cp -r deps/BreezeX_Cursor/themes/BreezeX-Black "$outdir"/
    cp -r deps/BreezeX_Cursor/themes/BreezeX-Dark "$outdir"/
    cp -r deps/BreezeX_Cursor/themes/BreezeX-Light "$outdir"/
  '';

  meta = with lib; {
    description = "extended KDE cursor.";
    homepage = "https://github.com/ful1e5/BreezeX_Cursor";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
