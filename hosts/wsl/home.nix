{ ... }:

{
  imports = [
    ../common.nix
    ../../modules/services/background.nix
  ];

  # Chrome exclusivo para WSL.
  programs.zsh.shellAliases.chrome =
    "chrome --disable-gpu --use-gl=angle --use-angle=swiftshader --enable-unsafe-swiftshader --no-sandbox >/dev/null 2>&1 &";
}
