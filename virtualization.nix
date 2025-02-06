{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # Auto update containers
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      watchtower = {
        image = "containrrr/watchtower";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
      };
    };
  };

  virtualisation.lxd = {
    enable = true;
    ui.enable = true;
    recommendedSysctlSettings = true;
  };
}
