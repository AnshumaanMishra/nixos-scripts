{
  description = "Development environment with unstable Eden";

  inputs = {
    # We only need the unstable channel for this specific shell
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs-unstable, ... }: 
    let
      system = "x86_64-linux"; # Change if on ARM
      
      # Instantiate the unstable package set
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        # config.allowUnfree = true; # Uncomment if eden or its dependencies require it
      };
    in {
      # Define the default development shell for this system
      devShells.${system}.default = pkgs-unstable.mkShell {
        # Add your packages here
        packages = [
          pkgs-unstable.eden
        ];

        # Optional: A nice greeting when you enter the shell
        shellHook = ''
          echo "Entering unstable dev environment..."
          echo "The 'eden' command is now available."
        '';
      };
    };
}
