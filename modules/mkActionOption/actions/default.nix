{
  actionConfig ? null,
  lib,
  onlyGestureSafeActions ? false,
  ...
}: let
  # ----- INHERITANCE -----
  inherit (lib.attrsets) optionalAttrs;

  # ----- INDIVIDUAL ACTIONS -----
  # Final actions
  finalActions = {
    none = import ./none.nix;
    keyPress = import ./keyPress.nix {inherit lib;};
  };

  # Intermediate actions (actions that hold other actions
  intermediateActions = optionalAttrs (actionConfig != null) {
    gestures = import ./gestures.nix {
      inherit lib;
      gesturesConfig = actionConfig."gestures".options;
    };
  };
in
  # ----- ACTION SET -----
  (
    # Base actions
    finalActions
    # If only gesture safe actions is false, then add remaining actions.
    // (optionalAttrs (!onlyGestureSafeActions) intermediateActions)
  )
