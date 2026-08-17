# Reminder that CUPS cpanel defaults to localhost:631
# Printer lives in another subnet (10.8.11.x), so mDNS discovery can't reach
# it — the queue is declared statically via its fixed IP instead.
{pkgs, ...}: {
  services.printing.enable = true;
  services.printing.drivers = [pkgs.epson-escpr2];

  hardware.printers = {
    ensurePrinters = [
      {
        # Native ESC/P-R rather than model = "everywhere": IPP Everywhere caps
        # rastering at 600x300dpi (too coarse for tiptoi OID dot patterns) and
        # makes lpadmin query the printer at activation time, which breaks
        # ensure-printers whenever we're outside the office network.
        # ET-4856 belongs to the ET-4850 series.
        name = "Epson-EcoTank";
        deviceUri = "socket://10.8.11.161:9100";
        model = "epson-inkjet-printer-escpr2/Epson-ET-4850_Series-epson-escpr2-en.ppd";
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
