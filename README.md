Video Tutorial:
https://www.youtube.com/watch?v=AGVXJ-TIv3Y

- overlays: [1:14:00](https://youtu.be/AGVXJ-TIv3Y?t=4652)
- upgrading: [1:21:00](https://youtu.be/AGVXJ-TIv3Y?t=4880)

## Nix the language

Run files and eval on changes:
`ls | entr -c bash -c 'nix-instantiate --eval --strict --arg x 1'`

https://www.youtube.com/watch?v=m4sv2M9jRLg

### Basic syntax:

- `;` - terminates a statement
- `:` - indicates function arguments
- `++` - add lists together
- `some ${type} string` - string interpolation with ${xxx}
- `[123 ./foo.nix "abc"]` - Lists can mix types
- `{ a = "Foo"; b = ./Bar }` - Name/value pairs ending with;
- `./hello` or `<nixpkgs>` - Square braces resolve from `NIX_PATH`
- `import` import one nix file into another
- `derivations` creates a derivation. Almost never used. The function `mkDerivation` is a wrapper which provides many niceties.

### Function declaration

Functions in Nix have only one argument only, ever!

[video 4:26](https://youtu.be/m4sv2M9jRLg?t=266)

```nix
nix-repl> dbl = x: x * 2
nix-repl> dbl 5
10
```

```nix
nix-repl> add = x: y: x + y
nix-repl> add 2 2
4

# Internally these are actually two functions:
# - one with argument x
# - one with argument y
```

Pass arguments via a set is most common in Nix

```nix
# x ? 2 means argument x has a default value 2
nix-repl> add = {x ? 2, y ? 2}: x + y
nix-repl> add {x = 1;}
3
nix-repl> add { x = 1; }
3
nix-repl> add { x = 1; y = 2; }
3
nix-repl> add { x = 1; y = 10; }
11
```

The `let` / `in` block allows for defining things you want to use but not return.

```nix
{ input ? "default" }: # single argument given to the function
let
  aSet = {
    inherit input; # same as input = input
    aString = "something-${input}";
    aList = ["list" "of" "strings" input];
  };
in
  aSet # aSet is returned here
```

### Importing files

```nix
# meta.nix
{uname, repo}:
{
  description = "A description";
  github = "https://github.com/${uname}";
  repository = "https://github.com/${uname}/${repo}";
}
```

```nix
# default.nix
let
  uname = "lnbits";
  repo = "lnbits_legend";
  src = import ./meta.nix { inherit uname repo; };
in
  stdenv.mkDerivation {
    inherit uname repo src;
  }
```

### Derivations

[video 12:58](https://youtu.be/m4sv2M9jRLg?t=778)

A derivation is a Nix expression that describes everything that goes into a package build action:

- Build tools
- Libraries
- Sources
- Build scripts
- Environment variables

Nix tries very hard to ensure that Nix expressions are deterministic: building a Nix expression twice should yield the same result.

Derivations are made with `derivations` primitive or extended `mkDerivation` function.

### Example package

```nix
stdenv.mkDerivation rec {
  pname = "hello";
  version = "2.10";

  src = fetchurl {
    url = "mirror://gnu/hello/${pname}-${version}.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  }

  meta = with stdenv.lib; {
    homepage = "https://www.gnu.org/software/hello/manual/";
    license = licenses.gpl3Plus;
    ...
  };
};
```

### How is a derivation made?

[video 14:10](https://youtu.be/m4sv2M9jRLg?t=851)

The `mkDerivation` function is an extended version of the built-in `derivation` and it’s defined in the `nixpkgs` repository in `pkgs/stdenv/generic/make-derivation.nix`.
It takes arguments like:

- `pname` - Name of the package, user in Nix store path.
- `version` - Self explanatory, also used in the path.
- `src` - Source for the package, usually acquired with `fetchgit` or `fetchurl`.
- `srcs` - Same as `src` except it’s a list.
- `buildInputs` - List of packages necessary for build. Tools end up in `PATH`.
- `configureFlags` - Flags for running `./configure` for package.
- `patches` - List of `.patch` files to apply to the package sources.
- `phases` - Way to customize which phases of build run and which don’t.
- `meta` - Meta data including maintainers, licenses, and description.
- And many others. . .

... and creates a `.drv` file which contains all the necessary inputs to build the package.

## nix os

### general

- run garbage collction: `nix-collect-garbage` or all in one `nix-collect-garbage -d`
  - :information_source: run this as sudo from time to time as it'll find more stuff to remove
- upgrade packages: `sudo nixos-rebuild switch --upgrade`
- where generations are stored

```sh
[f44@nixos:~/dev/stuff/nix-files]$ ls /nix/var/nix/profiles/
per-user/       system-11-link/ system-14-link/ system-17-link/ system-1-link/  system-4-link/  system-7-link/
system/         system-12-link/ system-15-link/ system-18-link/ system-2-link/  system-5-link/  system-8-link/
system-10-link/ system-13-link/ system-16-link/ system-19-link/ system-3-link/  system-6-link/  system-9-link/
```

### nix-shell

- ephemerally install an app: `nix-shell -p htop`

### nix package manager

Using nix-env to install packages is kindof not recommended. Use /etc/nixos/configuration.nix or a temp environment instead.

- search for packages: https://search.nixos.org/packages
- install a package `nix-env -iA nixos.htop`
- query packages that are installed via above cmd: `nix-env -q`
- uninstall a package `nix-env --uninstall nixos.htop`
- update packages installed via `nix-env -iA`: `nix-env -u '*'`
- list generations: `nix-env --list-generations`
- delete old generations: `nix-env --delete-generatons 14d` or `nix-env --delete-generatons 10 11`
- optimize the store: `nix-store --gc`

## HomeManager

[1:29:00](https://youtu.be/AGVXJ-TIv3Y?t=5614)
Home Manager is like configuration.nix, but for the user environment. More options to declare packages and manage dotFiles.

### Getting started

- :octocat: https://github.com/nix-community/home-manager
- :closed_book: https://nix-community.github.io/home-manager/index.html
- :pencil2: https://nix-community.github.io/home-manager/options.html

### Install

- as a NixOS module: https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
- :warning: make sure to run this as sudo an once as non-sudo. Reasin is that configuration.nix can only be edited as as sudo user

### adding user packages

### managing dotfiles

#### Add text to a file directly

```nix
home.file = {
  ".config/subfolder/file.yml".text = ''
Add text here directöy
''
};
```

### Flakes

[1:57:500](https://youtu.be/AGVXJ-TIv3Y?t=7070s)

Flakes specify code deps declaratively and will be stored in a flake.lock file. akes rebuilding and updating a system easier. Useful to build own OS configs:

- merge multiple configs into one
- Use github dotfiles

### Bitcoind

#### generate HMAC on linux commandline

```python
python3 -c 'import hashlib;import base64;import hmac;print(hmac.new(b"nonbase64key", "password".encode(), hashlib.sha256).hexdigest())'
```

### External resources

- Managing dot files with home manager: https://alexpearce.me/2021/07/managing-dotfiles-with-nix/

### FAQ:

#### _Q_ Why does installing VirtualBox via `nix-env -iA virtualbox` not compile from source, but installing via configuration.nix does?

> Would like to know

## Stuff

- nix-bitcoin talk: https://www.youtube.com/watch?v=oYnvvIyR8uA
- nix by example: https://jameshfisher.com/2014/09/28/nix-by-example/
- example xfce+bspwm example dotfiles: https://github.com/NiharKod/dots
- nixpacks https://github.com/railwayapp/nixpacks
- nix flakes tutorial https://serokell.io/blog/practical-nix-flakes
- another flakes tutorial: https://jdisaacs.com/blog/nixos-config/
- spawn a lightweight nixos vm https://github.com/Mic92/nixos-shell
