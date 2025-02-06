{pkgs, config, ...}: {
  environment.etc."nextcloud-admin-pass".text = "&EYv#f83t$W4";
  services.nginx.virtualHosts."localhost".listen = [ { addr = "100.93.235.113"; port = 8080; } ];

  services.nextcloud = {                
    enable = true;                   
    package = pkgs.nextcloud30;
    hostName = "mvxmt.tail8d155b.ts.net";
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar tasks;
    };
    extraAppsEnable = true;

    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
  };
}