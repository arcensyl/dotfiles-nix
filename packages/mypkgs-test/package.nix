{ lib, stdenv, ... }:

stdenv.mkDerivation rec {
  pname = "mypkgs-test";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    cp script.sh $out/bin/${pname}
    chmod +x $out/bin/${pname}
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Test package with a simple 'hello world' script";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
