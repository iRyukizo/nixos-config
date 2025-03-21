{ pkgs, ... }:

rec {
  createLichessBotWrapper = {
    configuration ? {
        token = "$LICHESS_API_KEY";
        url = "https://lichess.org/";
        engine = {
          dir = "./.";
          name = "engine";
          protocol = "uci";
        };
      }
    , tokenEnvEnable ? true
    }:

    pkgs.writeShellScriptBin "lichess-bot-wrapper" ''
      tmpConfig=$(mktemp /tmp/lichess-bot-config-XXXXX.yml)

      echo '${builtins.toJSON configuration}' > $tmpConfig

      ${if tokenEnvEnable then "${pkgs.envsubst}/bin/envsubst -i $tmpConfig -o $tmpConfig" else ""}

      ${pkgs.lichess-bot}/bin/lichess-bot --config $tmpConfig -- $@

      rm $tmpConfig
    '' // {
      propagatedBuildInputs = with pkgs; [
        envsubst
        lichess-bot
        mktemp
      ];
    };

  createLichessBotWrapperApp = {
    configuration ? {
        token = "$LICHESS_API_KEY";
        url = "https://lichess.org/";
        engine = {
          dir = "./.";
          name = "engine";
          protocol = "uci";
        };
      }
    , tokenEnvEnable ? true
    }:
    {
      type = "app";
      program = "${createLichessBotWrapper { inherit configuration tokenEnvEnable; }}/bin/lichess-bot-wrapper";
    };
}
