{
  delib,
  pkgs,
  lib,
  home,
  ...
}:
let
  inherit (lib) getExe genAttrs;
  inherit (lib.strings) splitString toInt;
  inherit (builtins)
    fromJSON
    head
    isFloat
    isInt
    isString
    ;
  system = pkgs.stdenv.hostPlatform.system;
in
delib.module {
  name = "functions";

  myconfig.always.args.shared.func = rec {
    /*
      mkList :: a -> [a]

      Ensure that a value is represented as a list.

      If the input is already a list, it is returned unchanged.
      Otherwise, the value is wrapped in a single-element list.

      This is commonly used for options that accept either a single
      value or a list of values.
    */
    mkList = x: if builtins.isList x then x else [ x ];

    # Check if input is a number
    isNumber = v: isInt v || isFloat v;

    # Converts the input to a float if possible (hacky but it works)
    toFloat =
      v:
      let
        strVal = fromJSON v;
        forceFloat = i: if isFloat i then i else i + 0.5 - 0.5;
      in
      assert (isNumber v || isString v);
      if isString v then
        forceFloat strVal
      else if isInt v then
        forceFloat v
      else
        v;

    # Round float to lower integer
    floor =
      f:
      let
        floatComponents = splitString "." (toString f);
        int = toInt (head floatComponents);
      in
      assert (isFloat f);
      int;

    # Round float to upper integer
    ceil =
      f:
      let
        int = div' f 1;
        inc = if mod' f 1 > 0 then 1 else 0;
      in
      assert (isFloat f);
      int + inc;

    # Round float to closest integer
    round =
      f:
      let
        int = div' f 1;
        inc = if mod' f 1 >= 0.5 then 1 else 0;
      in
      assert (isFloat f);
      int + inc;

    # Integer division for floats
    div' =
      n: d:
      assert (isNumber n);
      assert (isNumber d);
      floor (builtins.div (toFloat n) (toFloat d));

    # Module operator implementation for floats
    mod' =
      n: d:
      let
        f = div' n d;
      in
      assert (isNumber n);
      assert (isNumber d);
      n - (toFloat f) * d;

    /*
      wrapUWSM :: string | package -> string

      Wrap a program so it is launched via `uwsm app --`.

      The argument may be either:
      - a string representing a command or executable path
      - a package, in which case its main executable is resolved
        using `lib.getExe`

      The result is a shell command string.
    */
    wrapUWSM = pkg: "${getExe pkgs.uwsm} app -- ${if builtins.isString pkg then pkg else getExe pkg}";

    /*
      flakePackage :: attrs -> package

      Get the default package from a flake.
    */
    flakePackage = flake: flake.packages.${system}.default;

    /*
      wrapLocal :: package -> package

      !!!!! Highly impure. Only for development !!!!!!
      Wrap the given package where it try to run the binary with same
      name from ~/.local/bin/{pname}. If not possible than run the
      binary of package.
    */
    wrapLocal =
      pkg:
      let
        pname = getExe pkg |> baseNameOf;
        localRun = lib.escapeShellArg /* bash */ ''
          local_override="$HOME/.local/bin/${pname}"
          if [ -x "$local_override" ]; then
            exec -a "$0" "$local_override" "$@"
            exit
          fi
        '';
      in
      pkgs.symlinkJoin {
        name = "${pname}-wrapped";
        meta.mainProgram = pname;
        paths = [ pkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = /* bash */ ''
          wrapProgram $out/bin/${pname} \
            --run ${localRun}
        '';
      };

    /*
      genMimes :: string | [string] -> [string] -> attrset

      Generate XDG MIME associations for desktop entries.

      Arguments:
      - desktops: a desktop file name or a list of desktop file names
      - types: a list of MIME types

      For each MIME type, the given desktop entries are:
      - added to `xdg.mimeApps.associations.added`
      - set as the default applications
    */
    genMimes =
      desktops: types:
      let
        mimes = genAttrs types (_: mkList desktops);
      in
      {
        associations.added = mimes;
        defaultApplications = mimes;
      };

    /*
      xdg :: attrset of (string -> string)

      Convenience helpers for constructing XDG paths.

      Each attribute is a function that takes a relative name and
      returns an absolute path inside the corresponding XDG directory.
    */
    xdg = {
      # Path under the ~/.local/bin/
      bin = name: "${home.home.homeDirectory}/.local/bin/${name}";
      # Path inside `$XDG_CACHE_HOME`.
      cache = name: "${xdg.cacheHome}/${name}";
      # Path inside `$XDG_CONFIG_HOME`.
      config = name: "${xdg.configHome}/${name}";
      # Path inside `$XDG_DATA_HOME`.
      data = name: "${xdg.dateHome}/${name}";
      # Path inside `$XDG_STATE_HOME`.
      state = name: "${xdg.stateHome}/${name}";
    };
  };
}
