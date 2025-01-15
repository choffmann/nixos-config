{
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  ...
}:
stdenv.mkDerivation {
  pname = "progeek-loading-plymouth-theme";
  version = "1.0";

  src =
    fetchFromGitHub
    {
      owner = "choffmann";
      repo = "progeek-loading-plymouth-theme";
      rev = "main";
      sha256 = "sha256-laGUUBCKcPVLSlDk7NFSsHolX10smCnED82L8J0DiSY=";
    };

  passthru.updateScript = unstableGitUpdater {};

  installPhase = ''
    runHook preInstall

    cd plymouth-theme
    mkdir -p $out/share/plymouth/themes/progeek_loading
    cp * $out/share/plymouth/themes/progeek_loading
    substituteInPlace $out/share/plymouth/themes/progeek_loading/progeek_loading.plymouth \
      --replace-fail "/usr/" "$out/"

    runHook postInstall
  '';
}
