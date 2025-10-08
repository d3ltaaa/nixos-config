{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "0.8.6";
  pname = "WinBoat";
  name = "winboat";

  src = fetchurl {
    url = "https://github.com/TibixDev/winboat/releases/download/v${version}/winboat-0.8.6-x86_64.AppImage";
    hash = "sha256-HSL95LhDTBaVeHT+w7teWQXkGlEDmkg+JEz2A7YQJCo=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  meta = {
    description = "Install WindowsApps on Linux";
    homepage = "https://www.winboat.app/";
    downloadPage = "https://github.com/TibixDev/winboat/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ TibixDev ];
    platforms = [ "x86_64-linux" ];
  };
}
