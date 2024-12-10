{pkgs, ...}: let
  sleepScript = pkgs.writeShellApplication {
    name = "sleep-wake-at";
    runtimeInputs = with pkgs; [
      util-linux
    ];

    text = ''
      rtcwake -m mem --date +300min
    '';
  };
in {
  systemd.timers."auto-sleep" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 2:00:00";
      Unit = "auto-sleep.service";
    };
  };

  systemd.services."auto-sleep" = {
    script = ''
      set -eu
      ${sleepScript}/bin/sleep-wake-at
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
