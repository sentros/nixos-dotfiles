{config, ...}: {
  # Enables the zenpower sensor in lieu of the k10temp sensor on Zen CPUs https://git.exozy.me/a/zenpower3
  # On Zen CPUs zenpower produces much more data entries
  boot.blacklistedKernelModules = ["k10temp"];
  boot.extraModulePackages = [config.boot.kernelPackages.zenpower];
  boot.kernelModules = ["zenpower" "nct6775"];
  boot.kernelParams = ["amd_pstate=active"];
}
