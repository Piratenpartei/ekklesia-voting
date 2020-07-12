{ sources ? null }:
let
  deps = import ./deps.nix { inherit sources; };
  inherit (deps) lib pkgs sassc javascriptDeps webfontsPath sassPath deform python;
  version = import ./git_version.nix { inherit pkgs; };

in
pkgs.runCommand "ekklesia-voting-static-${version}" {
  buildInputs = [ sassc ];
  inherit sassPath;
  src = ../src/ekklesia_voting;
} ''
  mkdir -p $out/css
  sassc -I $sassPath $src/sass/portal.sass $out/css/portal.css

  #cp -r $src/static/img $out
  cp -r ${javascriptDeps}/js $out
  cp -r ${webfontsPath} $out
  cp -r ${deform}/${python.sitePackages}/deform/static $out/deform

''
