{config, ...}: let
  certsPath = "${config.services.caddy.dataDir}";
in {
  services.caddy = {
    enable = true;
    virtualHosts."owui.mvxmt.treelar.xyz".extraConfig = ''
      tls ${certsPath}/_.mvxmt.treelar.xyz.crt ${certsPath}/_.mvxmt.treelar.xyz.key
      reverse_proxy :3000
    '';
  };
}
