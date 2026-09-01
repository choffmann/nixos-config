# PostgreSQL client tooling (psql, pg_dump, ...) without running a local server
{pkgs, ...}: {
  environment.systemPackages = [pkgs.postgresql];
}
