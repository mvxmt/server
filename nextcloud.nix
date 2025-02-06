{pkgs, config}: {
  services.nextcloud = {                
    enable = true;                   
    package = pkgs.nextcloud28;
    hostName = "mvxmt.tail8d155b.ts.net";
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) calendar tasks;
    };
    extraAppsEnable = true;

    config.adminpassFile = pkgs.writeFile "nextcloud-admin-pass" "&EYv#f83t$W4";
    config.dbtype = "sqlite";
  };
}