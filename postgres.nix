{
  config,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    settings = {
      # TODO: Actually turn on SSL
      # ssl = true;
      # ssl_cert_file = "${credsDir}/cert.pem";
      # ssl_key_file = "${credsDir}/key.pem";
    };
    extensions = ps: with ps; [postgis pg_repack pgvector];
    authentication = ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      # "local" is for Unix domain socket connections only
      local   all             all                                     trust
      # IPv4 local connections:
      host    all             all             127.0.0.1/32            trust
      host    all             all             100.64.0.0/10           trust
      # IPv6 local connections:
      host    all             all             ::1/128                 trust

      # Allow password auth for all other users
      host all all all scram-sha-256
    '';
  };

  services.pgadmin = {
    enable = true;
    settings = {
      DEFAULT_SERVER = "0.0.0.0";
      DEFAULT_BINARY_PATHS = {
        "pg-16" = "${config.services.postgresql.package}/bin";
      };
    };
  };
}
