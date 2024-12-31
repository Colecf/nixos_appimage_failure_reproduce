{
  inputs = {
    nixpkgs2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs2405.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs =
    {
      self,
      nixpkgs2411,
      nixpkgs2405,
      ...
    }:
    {
      nixosConfigurations = {
        mysystem2411 = nixpkgs2411.lib.nixosSystem {
          modules = [ ./configuration.nix ];
          specialArgs = {
            is2411 = true;
          };
        };
        mysystem2405 = nixpkgs2405.lib.nixosSystem {
          modules = [ ./configuration.nix ];
          specialArgs = {
            is2411 = false;
          };
        };
      };
    };
}
