{ nixpkgs ? import ./nixpkgs.nix
}: let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) yarn yarn2nix nodejs-10_x nodePackages_10_x mkShell awscli aws-sam-cli psc-package;
  rootDir = builtins.toPath ./..;
in mkShell {
  buildInputs = [
    yarn
    yarn2nix
    nodejs-10_x
    nodePackages_10_x.lerna
    psc-package
  ];

  shellHook = ''
    export OLD_PATH=$PATH
    export PATH=$PATH:${rootDir}/bin
  '';
}
