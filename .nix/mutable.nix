{ nixpkgs ? import ./nixpkgs.nix
}: let
  inherit (nixpkgs) pkgs;
  inherit (pkgs)
    yarn
    nodejs-12_x
    nodePackages_10_x
    mkShell
    awscli
    aws-sam-cli
    psc-package
    entr
    purescript;
  rootDir = builtins.toPath ./..;
in mkShell {

  buildInputs = [
    # yarn will use nodejs v10 to run since v12 package sets aren't generated in this
    # nixpkgs pinned verison yet
    yarn
    # lerna will use nodejs v10 for same reason as yarn...
    nodePackages_10_x.lerna

    # our project source will be run through v12 though...
    nodejs-12_x

    # Pull in Purescript as "global" project dependency in the Nix shell and pull out
    # of devenv since Nix is more reliable than Node.js dependencies :)
    purescript

    # Necessary Purescript dependency manager for simplicity, I don't want to explain
    # Dhall for Purescript n00bs...
    psc-package

    # Used for watching files...
    entr
  ];

  shellHook = ''
    export OLD_PATH=$PATH
    export PATH=$PATH:${rootDir}/bin
  '';
}
