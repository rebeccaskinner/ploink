{ mkDerivation, aeson, base, bytestring, github, http-client
, http-client-tls, mtl, stdenv, text, transformers
}:
mkDerivation {
  pname = "ploink";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring github http-client http-client-tls mtl text
    transformers
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  license = stdenv.lib.licenses.asl20;
}
