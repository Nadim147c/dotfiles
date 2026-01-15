{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "weather";
  partof = "programs.quickshell";
  package = pkgs.writeNuApplication {
    inherit name;
    runtimeInputs = with pkgs; [ jq ];
    text = /* nu */ ''
      # Get current weather states as json. Data is cached for 10min in /tmp/weather.json.
      def main [] {
        let file = "/tmp/weather.json"

        let time  = date now | into int | $in / (10min | into int) | math floor
        if ($file | path exists) and (open $file | get time) == $time {
          print --stderr "Cached weather data"
          cat $file
          return
        }

        let data = curl -s wttr.in?format=j1 | jq '{
          current: .current_condition[0],
          location: .nearest_area[0],
          astronomy: .weather[0].astronomy[0]
        }' | from json | upsert time $time

        $data | save --force $file

        print $data
      }
    '';
  };
}
