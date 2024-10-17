{pkgs, ...}: let
  sleepScript = pkgs.writeShellApplication {
    name = "sleep-wake-at";
    runtimeInputs = with pkgs; [
      util-linux
    ];

    text = ''
      rtcwake --date +300min
    '';
  };
in {
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 2 * * * ${sleepScript}/bin/sleep-wake-at"
    ];
  };
}
