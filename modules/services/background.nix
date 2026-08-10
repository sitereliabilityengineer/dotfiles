{ pkgs, ... }:

{
  systemd.user.services.keep-awake = {
    Unit = { Description = "Mantiene Teams activo enviando F15 a Windows"; };
    Install = { WantedBy = [ "default.target" ]; };
    Service = {
      ExecStart = "${pkgs.writeShellScriptBin "keep-awake" (builtins.readFile ../../bin/keep-awake.sh)}/bin/keep-awake";
      Restart = "always";
      RestartSec = "10";
    };
  };
}
