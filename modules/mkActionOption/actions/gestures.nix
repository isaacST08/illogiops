{
  gesturesConfig,
  lib,
  ...
}: let
  # ----- INHERITANCE -----
  inherit (lib) mkOption;
  inherit (lib.modules) mkForce;

  # ----- FUNCTIONS -----
  mkActionOption = import ./../../mkActionOption;

  # ----- GESTURE -----
  # Define a single gesture
  gesture = {name, ...}: let
    direction = name;

    gestureConfig = gesturesConfig.gestures."${direction}";
  in {
    options = {
      direction = mkOption {
        type = with lib.types;
          enum [
            "up"
            "down"
            "left"
            "right"
            "none"
          ];
        description = ''
          Defines the direction of the gesture.
        '';
      };
      threshold = mkOption {
        type = lib.types.ints.positive;
        default = 50;
        description = ''
          This is an optional integer field that determines the number
          of pixels at which a gesture should activate.
        '';
      };
      mode = mkOption {
        type = with lib.types;
          enum [
            "NoPress"
            "OnRelease"
            "OnInterval"
            "OnThreshold"
            "Axis"
          ];
        default = "OnRelease";
        description = ''
          This is an optional string field that defines the mode of
          the gesture. This field defaults to OnRelease if it is
          omitted.

          The following is a list of gesture modes:

            - NoPress:
              This mode does nothing. The action field is ignored
              when this mode is used. This gesture is compatible with
              scroll wheels.

            - OnRelease:
              This mode presses and releases an action when the
              gesture button is released. This gesture is not
              compatible with scroll wheels.

            - OnInterval:
              This mode presses and releases an action after the
              mouse is moved every n pixels (where n is the integer
              field interval). This gesture is compatible with scroll
              wheels.

            - OnThreshold:
              Activates once the threshold is met, and never again.

            - Axis:
              This mode maps a gesture movement to an axis. The axis
              is defined as a string (e.g. "REL_WHEEL") in the axis
              field and the multiplier for its movement is defined in
              the axis_multiplier field. For a list of axis strings,
              refer to linux/input-event-codes.h. This gesture is
              compatible with scroll wheels.
        '';
      };
      action = mkActionOption {
        inherit lib;
        actionConfig = gestureConfig.action;
        calledFromGestureAction = true;
        description = ''
          The action to perform for this gesture.
        '';
      };
    };

    config = {
      direction = mkForce direction;
    };
  };
in {
  options = {
    gestures = mkOption {
      description = ''
        This is a required array of gesture objects that map a direction to
        a gesture mode and an action.
      '';
      type = with lib.types; attrsOf (submodule gesture);
    };
  };
}
