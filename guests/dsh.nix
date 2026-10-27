{ lib, dsh, ... }:

{
  imports = [ ./common.nix ];

  llmjail.toolBinary = lib.getExe dsh;
  llmjail.dangerousFlag = "";

  environment.systemPackages = [
    dsh
  ];
}
