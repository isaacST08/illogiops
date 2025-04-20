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
    changeDPI = import ./changeDPI.nix {inherit lib;};
    changeHost = import ./changeHost.nix {inherit lib;};
    cycleDPI = import ./cycleDPI.nix {inherit lib;};
    keypress = import ./keypress.nix {inherit lib;};
    none = import ./none.nix;
    toggleHiresScroll = import ./toggleHiresScroll.nix {inherit lib;};
    toggleSmartShift = import ./toggleSmartShift.nix {inherit lib;};
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
