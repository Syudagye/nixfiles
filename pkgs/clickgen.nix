{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pillow
, toml
, numpy
, attrs
, libX11
, libXcursor
, libpng
, python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clickgen";
  version = "2.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "clickgen";
    rev = "v${version}";
    sha256 = "0b4iba4cjgv8ji1rqyqkvjh3a1v18czjp8idvjjvq2cahxy94dm8";
  };

  buildInputs = [ libXcursor libX11 libpng ];

  propagatedBuildInputs = [ pillow toml numpy attrs ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "clickgen" ];

  meta = with lib; {
    homepage = "https://github.com/ful1e5/clickgen";
    description = "The hassle-free cursor building toolbox";
    longDescription = ''
      clickgen is API for building X11 and Windows Cursors from
      .png files. clickgen is using anicursorgen and xcursorgen under the hood.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AdsonCicilioti ];
    # fails with:
    # ld: unknown option: -zdefs
    broken = stdenv.isDarwin;
  };
}
