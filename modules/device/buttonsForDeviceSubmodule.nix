# First take in lib and the config containing all the devices.
{
  lib,
  devicesConfig,
  ...
}:
# Next take in the name of the device to generate button config for.
deviceName: let
  # Get the config path for the buttons for the requested device.
  buttonsConfig = devicesConfig."${deviceName}".buttons;
in
  # Return an attrset of button sub-modules.
  lib.types.attrsOf (lib.types.submodule (import ./button.nix {inherit lib buttonsConfig;}))
