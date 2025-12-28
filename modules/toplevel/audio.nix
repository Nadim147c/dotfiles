{ delib, ... }:
delib.module {
  name = "audio";

  options = delib.singleEnableOption true;

  nixos.ifEnabled.services.pipewire = {
    enable = true;
    pulse.enable = true; # replace PulseAudio
    jack.enable = true; # replace JACK
    alsa.enable = true; # replace ALSA
    alsa.support32Bit = true; # for 32-bit apps (e.g., Steam)
  };
}
