_: {
  services.vault = {
    enable = true;
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
