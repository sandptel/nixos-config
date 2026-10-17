{ ... }:
{
  # Realtek RTL8852CE (rtw89_8852ce) drops to RX-stall after idle while the AP
  # stays fine — the driver's power-save / PCIe-ASPM handling. Disable both the
  # NetworkManager 802.11 powersave and the driver's power-save mode.
  networking.networkmanager.wifi.powersave = false;

  boot.extraModprobeConfig = ''
    options rtw89_core disable_ps_mode=1
    options rtw89_pci disable_aspm_l1=1 disable_aspm_l1ss=1
  '';

  # ASPM L1 off: kills ~20ms latency spikes in online games; costs a bit of battery.
}
