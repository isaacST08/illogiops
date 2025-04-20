{
  actionConfig,
  lib,
  description,
  calledFromGestureAction ? false,
  ...
}: let
  # ----- INHERITANCE -----
  inherit (builtins) attrNames;
  inherit (lib) mkOption;
  inherit
    (lib.types)
    attrsOf
    submodule
    enum
    either
    str
    ;
  inherit (lib.modules) mkForce;

  # ----- FUNCTIONS -----
  attrsSubmodule = module: attrsOf (submodule module);

  # ----- ACTIONS -----
  # The set of actions that are options
  actionSet = import ./actions {
    inherit lib actionConfig;
    onlyGestureSafeActions = calledFromGestureAction;
  };

  # A list of the names of the permitted actions.
  permittedActions = enum (attrNames actionSet);
in
  mkOption {
    inherit description;
    default = {};

    type = either str (
      attrsOf (
        submodule (
          {name, ...}: let
            # The name of the calling attrs is the type of the action.
            actionType = name;

            # The sub-module of the selected action type.
            selectedActionSubmodule = submodule (actionSet."${actionType}");
          in
            # selectedActionOptions = actionSet."${actionType}".options;
            {
              options = (
                {
                  # The action type must be one of the available options.
                  type = mkOption {
                    type = permittedActions;
                    description = ''
                      The type of the action.

                      A gesture cannot have another gesture as its action.
                    '';
                  };

                  # The options for the action must match those of the selected action
                  # type.
                  options = mkOption {
                    type = selectedActionSubmodule;
                    description = "The options for the action.";
                  };

                  # "${actionType}helloworld" = mkOption {
                  #   type = lib.types.str;
                  #   default = "helloworld";
                  # };
                }
                # Merge the options of the selected action into the base action attrset
                # // selectedActionOptions
              );

              config = {
                type = mkForce actionType;
              };
            }
        )
      )
    );
  }
