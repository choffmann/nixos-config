{...}:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Auto mount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
