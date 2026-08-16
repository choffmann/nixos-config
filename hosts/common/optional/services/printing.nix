# Reminder that CUPS cpanel defaults to localhost:631
# Printer lives in another subnet (10.8.11.x), so mDNS discovery can't reach
# it — the queue is declared statically via its fixed IP instead.
{...}: {
  services.printing.enable = true;

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Epson-EcoTank";
        deviceUri = "ipp://10.8.11.161/ipp/print";
        # "everywhere" queries the printer for its PPD at activation time;
        # ensure-printers fails (harmlessly) if the printer is unreachable
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "Epson-EcoTank";
  };

  # Mitigate cups and avahi security issue as described here: https://discourse.nixos.org/t/cups-cups-filters-and-libppd-security-issues/52780/2
  # Note: this will eventually be achievable with the option `services.printing.browsed.enabled = false` but the PR hasn't been merged to unstable as of 09.10.24
  systemd.services.cups-browsed = {
    enable = false;
    unitConfig.Mask = true;
  };
}
