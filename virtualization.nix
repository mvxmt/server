{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  # Spice
  networking.firewall.allowedTCPPorts = [
    5900
  ];

  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
}
