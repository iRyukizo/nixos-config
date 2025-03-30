{ pkgs, ... }:

let
  defaultLichessBotConfiguration = {
    token = "$LICHESS_API_KEY";
    url = "https://lichess.org/";
    engine = {
      dir = "./.";
      name = "engine";
      protocol = "uci";
    };
  };

  createLichessBotWrapper = { configuration ? defaultLichessBotConfiguration, environmentSubstitution ? true }:
    pkgs.writeShellScriptBin "lichess-bot-wrapper" ''
      tmpConfig=$(mktemp --tmpdir lichess-bot-config-XXX.yml)

      echo '${builtins.toJSON configuration}' > $tmpConfig

      ${if environmentSubstitution then "${pkgs.envsubst}/bin/envsubst -i $tmpConfig -o $tmpConfig" else ""}

      ${pkgs.lichess-bot}/bin/lichess-bot --config $tmpConfig $@

      rm $tmpConfig
    '' // {
      propagatedBuildInputs = with pkgs; [
        envsubst
        lichess-bot
        mktemp
      ];
    };

  createLichessBotWrapperApp = { configuration ? defaultLichessBotConfiguration, environmentSubstitution ? true }:
    {
      type = "app";
      program = "${createLichessBotWrapper { inherit configuration environmentSubstitution; }}/bin/lichess-bot-wrapper";
    };
in
{
  inherit
    createLichessBotWrapper
    createLichessBotWrapperApp;
}
