{pkgs, ...}: {
  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    storageBackend = "file";
    address = "0.0.0.0:8200";
    extraConfig = ''
      ui = true
    '';
  };

  networking.firewall.allowedTCPPorts = [
    8200
  ];
}
