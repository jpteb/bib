{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    crateName = "bib";
  in {
    # declare toolchain
    nci.toolchainConfig = ./rust-toolchain.toml;
    # declare projects
    nci.projects."bib".path = ./.;
    # configure crates
    nci.crates.${crateName} = {};
  };
}
