# Scripts

Esta pasta vai conter scripts auxiliares usados pelo build da ISO e pelo
Calamares.

Escopo inicial:

- configuracao pos-instalacao em chroot
- configuracao do Snapper, grub-btrfs e Btrfs Assistant
- instalacao do yay
- configuracao do Zsh e Oh My Zsh
- ajustes de drivers de video

Build local:

```bash
./scripts/build-iso.sh
```

Por padrao, o build usa `~/simplearch-build/work` e
`~/simplearch-build/out`. Para trocar:

```bash
BUILD_ROOT=/caminho/para/build ./scripts/build-iso.sh
```

Gerar pacote local do Calamares:

```bash
./scripts/build-calamares-package.sh
```

Criar o repositorio pacman local para pacotes gerados em `packages/`:

```bash
./scripts/build-local-repo.sh
```

O `build-iso.sh` chama esse script automaticamente se o repositorio local ainda
nao existir.

Criar o repositorio offline de pacotes opcionais usado pelo seletor de GPU:

```bash
./scripts/build-optional-repo.sh
```

O `build-iso.sh` tambem chama esse script automaticamente e copia o resultado
para `airootfs/opt/simplearch/offline-repo` no perfil temporario da ISO.
