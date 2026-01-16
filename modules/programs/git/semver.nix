{
  delib,
  pkgs,
  ...
}:
delib.script rec {
  name = "git-semver";
  partof = "programs.git";
  completion = {
    inherit name;
    commands = [
      { name = "current"; }
      { name = "next"; }
      { name = "prerelease"; }
    ];
  };
  package = pkgs.writeNuApplication {
    inherit name;
    runtimeInputs = with pkgs; [
      gum
      svu
    ];
    text = /* nu */ ''
      def main [] { }

      def 'main current' [] {
        svu current
      }

      def 'main next' [] {
        let version = svu next
        print $version
        gum confirm $"Do want to create new teg? \(($version)\)"
        git tag $version
      }

      def 'main prerelease' [] {
        let current = svu current --json | from json
        if "prerelease" not-in $current  {
          print --stderr "Current version does not have any pre-release!"
          exit 1
        }
        let next = $current | upsert build {|old| $old.build | default "0" | into int | $in + 1 }
        let version = $next | format pattern "{major}.{minor}.{patch}-{prerelease}.{build}"
        print $version
        gum confirm $"Do want to create new teg? \(($version)\)"
        git tag $version
      }
    '';
  };
}
