{ config, pkgs, lib, ... }:

with lib;
let
  package = with pkgs.python3Packages; buildPythonApplication rec {
    pname = "njuskalo-notifier";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "mratkovic";
      repo = "njuskalo-notifier";
      rev = "0c14ec334af6f22d09952145c38c1713493457bf";
      sha256 = "1wd547113ibm12xlh4119napn5m6fsmxl8bmgbhmlrxd98qp3y85";
    };

    propagatedBuildInputs = [
      scrapy
      tqdm
    ];

    meta = with lib; {
      description = "njuskalo.hr scraper that alerts when new ads matching given filters appear";
      homepage = https://github.com/mratkovic/njuskalo-notifier/;
      license = licenses.mit;
    };
  };
  cfg = config.services.njuskalo;
  dbDir = "/var/lib/njuskalo";
in {
  options.services.njuskalo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable njuskalo notifications
      '';
    };
    package = mkOption {
      type = types.package;
      default = package;
      defaultText = "./custom_packages/njuskalo-notifier.nix";
      description = ''
      '';
    };
    userAgent = mkOption {
      type = types.str;
      default = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1";
      description = ''
        User agent for requests
      '';
    };
    numPages = mkOption {
      type = types.int;
      default = 1;
      description = ''
        How many pages are parsed for new ads
      '';
    };
    interval = mkOption {
      type = types.int;
      default = 60;
      description = ''
        How often to run the checks
      '';
    };
    urls = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        The urls to check. Example:
        urls = {
          stanNajamZagreb = "http://www.njuskalo.hr/iznajmljivanje-stanova?locationId=1153&price[max]=500";
          stanNajamSplit = "http://www.njuskalo.hr/iznajmljivanje-stanova?locationId=1578&price[max]=500";
        };
      '';
    };
    pipelinePriorities = {
      filterNew = mkOption {
        type = types.int;
        default = 200;
        description = ''
        '';
      };
      email = mkOption {
        type = types.int;
        default = 400;
        description = ''
        '';
      };
      print = mkOption {
        type = types.int;
        default = 600;
        description = ''
        '';
      };
    };
    email = {
      smtp = mkOption {
        type = types.str;
        default = "smtp.gmail.com";
        description = ''
          SMTP server address
        '';
      };
      port = mkOption {
        type = types.int;
        default = 587;
        description = ''
          SMTP port
        '';
      };
      username = mkOption {
        type = types.str;
        default = types.null;
        description = ''
          Email username
        '';
      };
      password = mkOption {
        type = types.str;
        default = types.null;
        description = ''
          Email password
        '';
      };
      recipient = mkOption {
        type = types.str;
        default = types.null;
        description = ''
          Email recipient
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.njuskalo = let
      configFile = pkgs.writeText "njuskalo_notifier.ini" (generators.toINI {} {
        URLs = cfg.urls;
        CRAWLER_PROCESS_SETTINGS = {
          smtp_server = cfg.email.smtp;
          port = cfg.email.port;
          username = cfg.email.username;
          app_password = cfg.email.password;
          recipient = cfg.email.recipient;
          n_pages = cfg.numPages;
          USER_AGENT = cfg.userAgent;
          db_path = dbDir + "/ads_dump.db";
        };
        ITEM_PIPELINES = {
          "sniffer_scraper.pipeline.SqliteFilterNewPipeline" = cfg.pipelinePriorities.filterNew;
          "sniffer_scraper.pipeline.EmailPipeline" = cfg.pipelinePriorities.email;
          "sniffer_scraper.pipeline.PrintPipeline" = cfg.pipelinePriorities.print;
        };
      });
    in {
      path = [cfg.package];
      description = "Njuskalo notifier service";
      serviceConfig = {
        Type = "oneshot";
        Restart = "no";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${dbDir}";
        ExecStart = ''
          ${cfg.package}/bin/njuskalo-notifier -c ${configFile}
        '';
      };
    };
    systemd.timers.njuskalo = {
      description = "Timer for the njuskalo notifier service";
      partOf = [ "njuskalo.service" ];
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = toString cfg.interval;
      };
    };
  };
}
