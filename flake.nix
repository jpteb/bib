{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nci.url = "github:yusdacra/nix-cargo-integration";
  inputs.nci.inputs.nixpkgs.follows = "nixpkgs";
  inputs.parts.url = "github:hercules-ci/flake-parts";
  inputs.parts.inputs.nixpkgs-lib.follows = "nixpkgs";

  outputs = inputs @ {
    # nixpkgs,
    parts,
    nci,
    ...
  }:
    parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        nci.flakeModule
        ./crates.nix
      ];
      perSystem = {
        pkgs,
        config,
        system,
        ...
      }: let
        # shorthand for accessing this crate's outputs
        # you can access crate outputs under `config.nci.outputs.<crate name>` (see documentation)
        crateOutputs = config.nci.outputs."bib";

        # pkgs = import inputs.nixpkgs { inherit system; };
      in {
        # export the crate devshell as the default devshell
        devShells.default = crateOutputs.devShell.overrideAttrs (old: {
          packages = (old.packages or []) ++ [
            # leptos
            pkgs.cargo-leptos
            pkgs.leptosfmt

            # dev
            pkgs.trunk
          ];
        });
        # export the release package of the crate as default package
        packages.default = crateOutputs.packages.release;
      };
    };
}
