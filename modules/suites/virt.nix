{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.virt;
in {
  options.suites.virt = {
    enable =
      lib.mkEnableOption "support for virtual machines powered by QEMU";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };

        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;

    boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

    boot.kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
    ];

    users.users."${vars.master.name}".extraGroups = [ "libvirtd" ];
    
    environment.systemPackages = with pkgs; [
      dnsmasq
      swtpm
      virt-manager
    ];

    networking.firewall.trustedInterfaces = [ "virbr0" ];
  };
}
