{
  inputs = {
    nixpkgs2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs2405.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager-2411 = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs2411";
    };
    home-manager-2405 = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs2405";
    };
  };

  outputs =
    {
      self,
      nixpkgs2411,
      nixpkgs2405,
      home-manager-2411,
      home-manager-2405,
      ...
    }:
    {
      nixosConfigurations = {
        mysystem2411 = nixpkgs2411.lib.nixosSystem {
          modules = [ ./configuration.nix ];
          specialArgs = {
            is2411 = true;
            home-manager = home-manager-2411;
          };
        };
        mysystem2405 = nixpkgs2405.lib.nixosSystem {
          modules = [ ./configuration.nix ];
          specialArgs = {
            is2411 = false;
            home-manager = home-manager-2405;
          };
        };
      };
    };
}
