{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "rider2emacs";
  version = "git-2022-07-31";

  src = fetchFromGitHub {
    owner = "elizagamedev";
    repo = "rider2emacs";
    rev = "46ef8d7bce97c5c47e42b629bf38d0970ff3a607";
    sha256 = "sha256-LIv8HR6lQLjotfJSmwBx01S8MdZ0qKyv0uB9uCCegPc=";
  };

  cargoHash = "sha256-5FG7rhcqY27YO2F858/DsfVGQuwNI8hdRDvHh6NmqQE=";
  
  meta = with lib; {
    description = "Translates Unity's JetBrains Rider invocations to call Emacs's client";
    homepage = "https://github.com/elizagamedev/rider2emacs";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
