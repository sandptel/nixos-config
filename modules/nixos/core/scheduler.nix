{ ... }:
{
  # sched-ext userspace scheduler. scx_lavd targets low-latency desktop/gaming
  # workloads and benefits modern multi-CCX CPUs (Zen 5). Reversible: remove file.
  # Requires a recent kernel (sched-ext landed in 6.12); we run linuxPackages_latest.
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
