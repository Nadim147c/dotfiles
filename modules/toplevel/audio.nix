{ delib, ... }:
delib.module {
  name = "audio";

  options = delib.singleEnableOption true;

  nixos.ifEnabled.services = {
    pipewire.enable = true;
    pipewire.pulse.enable = true; # replace PulseAudio
    pipewire.jack.enable = true; # replace JACK
    pipewire.alsa.enable = true; # replace ALSA
    pipewire.alsa.support32Bit = true; # for 32-bit apps (e.g., Steam)
  };
}
