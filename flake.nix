{
  inputs.flakelite.url = "github:accelbread/flakelite";
  outputs = { flakelite, ... }:
    flakelite ./. {
      devShell.packages = pkgs: with pkgs; [ python3Packages.west ];
    };
}
