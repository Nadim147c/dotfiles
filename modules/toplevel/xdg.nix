{
  delib,
  home,
  xdg,
  ...
}:
delib.module {
  name = "xdg";

  options = delib.singleEnableOption true;

  home.ifEnabled = {
    home.preferXdgDirectories = true;

    xdg = {
      enable = true;
      userDirs =
        let
          download = "${home.home.homeDirectory}/downloads";
          media = category: "${home.home.homeDirectory}/media/${category}";
          files = category: "${home.home.homeDirectory}/files/${category}";
        in
        {
          enable = true;
          createDirectories = true;
          download = download;
          desktop = files "desktop";
          documents = files "documents";
          music = media "music";
          pictures = media "pictures";
          publicShare = files "public-share";
          templates = files "templates";
          videos = media "videos";
        };
    };

    home.sessionVariables = {
      XDG_DESKTOP_DIR = xdg.userDirs.desktop;
      XDG_DOCUMENTS_DIR = xdg.userDirs.documents;
      XDG_DOWNLOAD_DIR = xdg.userDirs.download;
      XDG_MUSIC_DIR = xdg.userDirs.music;
      XDG_PICTURES_DIR = xdg.userDirs.pictures;
      XDG_PUBLICSHARE_DIR = xdg.userDirs.publicShare;
      XDG_TEMPLATES_DIR = xdg.userDirs.templates;
      XDG_VIDEOS_DIR = xdg.userDirs.videos;
    };
  };
}
