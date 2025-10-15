{
    config,
    delib,
    inputs,
    lib,
    modulesPath,
    ...
}:
delib.host {
    name = "chronoshift";

    system = "x86_64-linux";

    home.home.stateVersion = "25.11";
    nixos = {
        system.stateVersion = "25.05";

        imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            "${inputs.nixos-hardware}/common/cpu/intel/skylake"
        ];

        boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
        boot.initrd.kernelModules = [];
        boot.kernelModules = ["kvm-intel"];
        boot.extraModulePackages = [];
        boot.kernelParams = ["quiet" "video=eDP-1:d"];

        fileSystems."/" = {
            device = "/dev/disk/by-uuid/87cc385e-3fc4-4498-8eea-68c3067eaec8";
            fsType = "ext4";
        };

        boot.initrd.luks.devices."luks-87d908d4-65e5-4f74-a53b-a6d9ba2f7412".device = "/dev/disk/by-uuid/87d908d4-65e5-4f74-a53b-a6d9ba2f7412";
        boot.initrd.luks.devices."luks-8d9b5034-d1f3-420e-8f0d-c335e85d68d9".device = "/dev/disk/by-uuid/8d9b5034-d1f3-420e-8f0d-c335e85d68d9";

        fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/5402-A647";
            fsType = "vfat";
            options = ["fmask=0077" "dmask=0077"];
        };

        swapDevices = [
            {device = "/dev/disk/by-uuid/744be771-1a45-4a01-a168-d165b4e79eb3";}
        ];

        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
