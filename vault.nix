{pkgs, ...}: {
  services.vault = {
    enable = true;
    storageBackend = "file";
  };
}
