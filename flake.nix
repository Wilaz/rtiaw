{
  description = "Dev shell for running a Windows exe via Wine";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "openturing";
        version = "1.0";
        src = ./turing;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        installPhase = ''
          mkdir -p $out/share/openturing $out/bin
          cp -r ./ $out/share/openturing/

          makeWrapper ${pkgs.wineWowPackages.stable}/bin/wine $out/bin/openturing \
            --add-flags "$out/share/openturing/turing.exe $@"
        '';
      };
    };
}
