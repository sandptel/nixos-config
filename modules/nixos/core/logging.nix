{ ... }:
{
  # /var/log/journal is uncapped by default → grew to 1.1G of btrfs writes.
  # 500M keeps ~weeks of boots; journalctl --vacuum-size trims the existing one.
  services.journald.settings.Journal.SystemMaxUse = "500M";
}
