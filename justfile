# format all Nix and Lua files
format:
  stylua .
  alejandra .
  prettier -w .
  
update-packages-file:
  cp /etc/currentSystemPackages.txt .
