# Lerna-Yarn-Purescript-`psc-package` Project Template

This repository exists to explore how to setup a Lerna (multi-package) Yarn-based monorepo with Purescript projects integrated.

## Motivation

Having witnessed the micro repo approach to node packages in action - despite not being in total love with mono repos
philosophically - I would choose the monorepo approach as the lesser of two evils thus my interest in understanding how to use
Lerna with Yarn+`psc-package`-based Purescript packages to automate developer and CI/CD workflows.

## Bootstrapping

### `direnv` + Nix 2.2+

If you have Nix 2.2+ and `direnv` installed in user/system scope you just need to `direnv allow` at the root directory of the repo.

### Nix 2.2+

If you have Nix 2.2+ without `direnv` installed, try in the root directory of this repo:

```
nix-shell
```

### All Others

If you do not have Nix 2.2+ installed then you need to use your favorite package manager to install the following:

```
Nix:	2.2.2
Yarn:	1.13.0
Node:	v10.15.3
Lerna:	3.13.0
Purs:   1.13.0
```

## Organization

This _"monorepo"_ has a Node package with Lerna configured at the root level and reusable/publishable packages
under `pkgs/` and applications that use those packages under `apps/`.
