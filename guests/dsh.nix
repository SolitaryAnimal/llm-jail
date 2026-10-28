{ lib, pkgs, dsh, ... }:

{
  imports = [ ./common.nix ];

  # dsh is a web application: `dsh web` boots the shipped web profile and
  # serves the GUI on a concrete local address (wildcard binds are refused).
  # The runner forwards host 127.0.0.1:3080 to the guest's slirp address, and
  # --public-url makes the printed tokenized URL usable from the host browser.
  llmjail.toolBinary = pkgs.writeShellScript "dsh-launcher" ''
    if [ "$#" -eq 0 ]; then
      guest_ip="$(${pkgs.iproute2}/bin/ip -4 -o addr show dev eth0 | ${pkgs.gawk}/bin/awk '{ sub(/\/.*/, "", $4); print $4; exit }')"
      set -- web --no-open \
        --host "''${guest_ip:-10.0.2.15}" \
        --port 3080 \
        --public-url http://127.0.0.1:3080/
    fi
    exec ${lib.getExe dsh} "$@"
  '';
  llmjail.dangerousFlag = "";

  environment.systemPackages = [
    dsh
  ];
}
