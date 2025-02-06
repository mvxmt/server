{pkgs, config, ...}: {
  environment.etc."nextcloud-admin-pass".text = "&EYv#f83t$W4";

  environment.etc."nextcloud-whiteboard-secret".text = ''
    JWT_SECRET_KEY=00408165cbc91e10c7ca8c99574fe57d
  '';

  services.nginx.virtualHosts."mvxmt.tail8d155b.ts.net".listen = [ { addr = "100.93.235.113"; port = 8080; } ];

  services.nextcloud = {                
    enable = true;                   
    package = pkgs.nextcloud30;
    hostName = "mvxmt.tail8d155b.ts.net";
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar tasks whiteboard contacts notes deck;
    };
    extraAppsEnable = true;

    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
  };

  services.nextcloud-whiteboard-server = {
    enable = true;
    settings = {
      NEXTCLOUD_URL = "http://mvxmt.tail8d155b.ts.net:8080";
    };
    secrets = [ "/etc/nextcloud-whiteboard-secret" ];
  };
}