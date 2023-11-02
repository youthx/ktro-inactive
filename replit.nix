{ pkgs }: {
    deps = [
      pkgs.hexdump
		pkgs.nodePackages.prettier
      pkgs.cowsay
    ];
}