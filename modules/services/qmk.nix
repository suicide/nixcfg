{...}: {
  internal.modules = {
    nixos.qmk = {
      hardware.keyboard.qmk.enable = true;
    };
  };
}
