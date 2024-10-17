{config}:let
  certsPath = "${config.users.users.ninjawarrior1337.home}/.lego/certificates";
in {
  services.caddy = {
    enable = true;
    virtualHosts."ollama.mvxmt.treelar.xyz".extraConfig = ''
      tls ${certsPath}/_.mvxmt.treelar.xyz.crt ${certsPath}/_.mvxmt.treelar.xyz.key
      reverse_proxy :3000
    '';
  };
}