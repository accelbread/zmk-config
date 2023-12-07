{
  inputs.flakelite.url = "github:accelbread/flakelite";
  outputs = { flakelite, ... }:
    flakelite ./. {
      devTools = pkgs: with pkgs; [ python3Packages.west ];
    };
}
