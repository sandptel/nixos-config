{ ... }:
{
  # sched-ext userspace scheduler. scx_lavd targets low-latency desktop/gaming
  # workloads and benefits modern multi-CCX CPUs (Zen 5). Reversible: remove file.
  # Requires a recent kernel (sched-ext landed in 6.12); we run linuxPackages_latest.
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";

    # Power mode ← the active power-profiles-daemon profile, instead of lavd's
    # default load-based autopilot. On balanced/power-saver this turns on core
    # compaction: pack work onto one CCX rather than spreading it across both.
    extraArgs = [ "--autopower" ];
  };
}
