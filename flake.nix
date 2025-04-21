{
  description = "A flake to configure logiops using the nix config language.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
  };

  outputs = {self, ...} @ inputs: let
    illogiopsLib = import ./lib {
      inherit (inputs.nixpkgs) lib;
    };
  in {
    nixosModules = {
      illogiops = import ./modules {
        specialArgs = {
          inherit illogiopsLib;
        };
      };
      default = self.nixosModules.illogiops;
    };
  };
}
