_: {
  services.vault = {
    enable = true;
    storageBackend = "file";
    address = "0.0.0.0:8200";
    services.vault.extraConfig = ''
      ui = true
    '';
  };

  networking.firewall.allowedTCPPorts = [
    8200
  ];
}
