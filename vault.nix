_: {
  services.vault = {
    enable = true;
    storageBackend = "file";
    address = "0.0.0.0:8200";
  };

  networking.firewall.allowedTCPPorts = [
    8200
  ];
}
