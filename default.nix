# Build Python package.
# Can be installed in the current user profile with:
# nix-env -if .
{ sources ? null }:
let
  deps = import ./nix/deps.nix { inherit sources; };
  inherit (deps) babel pkgs mkPoetryApplication python pyProject;
  inherit (deps.pyProject) version;

in mkPoetryApplication {
  doCheck = false;
  projectDir = ./.;
  inherit python version;
  src = pkgs.nix-gitignore.gitignoreSource
    [ "cookiecutter" ]
    ./.;

  passthru = {
    inherit deps version;
  };

  postInstall = ''
    ${babel}/bin/pybabel compile -d $out/${python.sitePackages}/ekklesia_voting/translations
  '';
}
