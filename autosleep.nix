{pkgs, ...}: let
  sleepScript = pkgs.writeShellScriptBin "sleep-and-wake-at" ''

  '';
in {
  services.cron = {
    enable = true;
    systemCronJobs = ''
      0 2 * * *
    '';
  };
}
