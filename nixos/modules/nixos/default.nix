{ config, pkgs, inputs, ... }:

{
  imports =
    [
    	./main-user.nix
    ];
home-manager."emilio" = {
  extraSpecialArgs = {inherit inputs;};
  users = {
	  modules = [
		  ./home.nix
		  inputs.self.outputs.homeManagerModules.default
	  ];
  };
};

}
