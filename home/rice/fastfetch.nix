{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo.type = "small";
      display.separator = " : ";
      modules = [
        {
          type = "title";
          key = "  SYS";
          format = "{2}";
          keyColor = "red";
        }
        {
          type = "os";
          key = "  OS ";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = "  KER";
          keyColor = "green";
        }
        {
          type = "shell";
          key = "  SH ";
          keyColor = "blue";
        }
        {
          type = "terminal";
          key = "  TRM";
          keyColor = "green";
        }
        {
          type = "colors";
        }
      ];
    };
  };
}
