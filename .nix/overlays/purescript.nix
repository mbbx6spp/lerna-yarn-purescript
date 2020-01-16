self: super:
let
  purescriptSrcs = {
    darwin = self.fetchurl {
      url = "https://github.com/purescript/purescript/releases/download/v0.13.5/macos.tar.gz";
      sha256 = "19bb50m0cd738r353blgy21d842b3yj58xfbplk7bz59jawj9lym";
    };
    linux64 = self.fetchurl {
      url = "https://github.com/purescript/purescript/releases/download/v0.13.5/linux64.tar.gz";
      sha256 = "016wvwypgb4859f0n1lqsqv9a8cca2y8g7d6ffvzx6rncd115gxi";
    };
  };
in {
  purescript = super.purescript.overrideAttrs (oldAttrs: {
    version = "0.13.5";
    src = if self.stdenv.isDarwin
          then purescriptSrcs.darwin
          else purescriptSrcs.linux64;
  });
}
