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
  inherit (lib.types) attrsOf submodule enum;
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

    type = attrsSubmodule (
      {name, ...}: let
        # The name of the calling attrs is the type of the action.
        actionType = name;

        # The sub-module of the selected action type.
        selectedActionSubmodule = submodule (actionSet."${actionType}");
      in {
        options = {
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
        };

        config = {
          type = mkForce actionType;
        };
      }
    );
  }
