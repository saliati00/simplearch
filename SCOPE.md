# Escopo

Este documento define as decisoes iniciais de produto e implementacao do
SimpleArch.

## Base

- Base Arch Linux usando os repositorios oficiais sempre que possivel.
- ISO construida com `archiso`, a partir de um perfil `releng` modificado.
- Ambiente live com KDE Plasma e instalador Calamares.
- Desktop instalado com `plasma-meta`.
- Boot UEFI com GRUB; boot BIOS fica fora do escopo inicial.
- Filesystem Btrfs obrigatorio para permitir snapshots e rollback.
- NetworkManager, PipeWire, Bluetooth, UFW, Flatpak, plasma-login-manager e
  zram com zstd por padrao.
- Live ISO em ingles por padrao, com suporte a `pt_BR.UTF-8` disponivel no
  instalador. Idioma, teclado e timezone devem seguir a escolha do usuario no
  Calamares.
- `multilib` habilitado.
- Firefox como navegador padrao.
- MPV como reprodutor de video padrao.
- Zsh com Oh My Zsh por padrao para o usuario criado na instalacao.
- Pacotes de jogos nao entram na instalacao padrao.

## Armazenamento

A instalacao deve seguir, sempre que possivel, este layout:

- Particao EFI de 1 GiB montada em `/boot`.
- Particao Btrfs para o restante do sistema.
- Subvolume `@` montado em `/`.
- Subvolume `@home` montado em `/home`.
- Subvolume `@snapshots` montado em `/.snapshots`.
- Subvolume `@log` montado em `/var/log`.
- Subvolume `@pkg` montado em `/var/cache/pacman/pkg`.
- Compressao Btrfs com `compress=zstd`.

## Snapshots e Recuperacao

- Snapper configurado para o subvolume raiz.
- Retencao pre-configurada para manter snapshots por ate 3 dias.
- `ALLOW_USERS="wheel"` para permitir administracao pelo usuario criado.
- `snap-pac` para snapshots automaticos ao usar pacman.
- `grub-btrfs` para expor snapshots no menu do GRUB.
- `btrfs-assistant` como interface grafica.
- Timers e servicos necessarios habilitados automaticamente.
- GRUB regenerado apos a configuracao.

## Driver de Video

O Calamares deve expor uma escolha simples:

- Mesa, para Intel/AMD e uso geral.
- Nvidia proprietario, para GPUs Nvidia antigas quando necessario.
- Nvidia open DKMS, para GPUs Nvidia mais novas.

Pacotes esperados por opcao:

- Mesa: stack Mesa padrao do Arch.
- Nvidia proprietario: `dkms`, `linux-headers`, `nvidia-dkms` e
  `nvidia-utils`.
- Nvidia open DKMS: `dkms`, `linux-headers`, `nvidia-open-dkms` e
  `nvidia-utils`.

Os pacotes opcionais de Nvidia devem ser embarcados em um repositorio pacman
offline dentro do live ISO, sem serem instalados no sistema base. O Calamares
deve montar esse repositorio temporariamente apenas quando uma opcao Nvidia for
selecionada.

Pacotes `lib32` de Nvidia ficam fora da instalacao padrao, a menos que a lista
final de pacotes volte a incluir suporte a jogos ou aplicativos 32-bit.

## Terminal

- Instalar `zsh`, `zsh-completions`, `zsh-syntax-highlighting` e
  `zsh-autosuggestions`.
- Instalar Oh My Zsh para o usuario criado pelo Calamares.
- Definir `/bin/zsh` como shell padrao desse usuario.
- Criar um `.zshrc` inicial com tema `duellj`.
- Ativar os plugins `git`, `zsh-syntax-highlighting` e `zsh-autosuggestions`.
- Garantir que o Konsole abra usando o shell padrao do usuario.

## Pacotes

A lista final deve separar pacotes explicitamente desejados de dependencias
transitivas.

Entram como base:

- Sistema base Arch: `base`, kernel, firmware, microcode, ferramentas Btrfs e
  GRUB.
- KDE Plasma via `plasma-meta`.
- Ferramentas basicas do KDE, como Dolphin, Konsole, Ark, Gwenview, Okular,
  Spectacle, Discover, MPV e System Settings quando nao vierem pelo meta
  pacote.
- Rede, audio, bluetooth, firewall, portais XDG e Flatpak.
- Ferramentas essenciais de terminal e manutencao: `sudo`, `git`, `curl`,
  `wget`, `vim` ou `nano`, `htop`, `ripgrep`, `openssh`, `usbutils`,
  `pciutils`, `smartmontools`, `unzip`, `zip`, `unrar`, `7zip`.
- Zsh, Oh My Zsh e plugins de shell definidos na secao Terminal.

Ficam fora do padrao:

- Steam.
- Heroic Games Launcher.
- GameMode.
- Pacotes `lib32` usados apenas por jogos.
- Brave.
- VS Code e outros aplicativos pessoais.

## Decisoes Pendentes

- Nome final e branding visual da distro.
- Se o KDE deve permanecer totalmente vanilla ou receber pequenos ajustes de
  conveniencia.
- Lista exata de pacotes explicitos em `packages.x86_64`.
- Politica final para instalacao do YAY dentro da ISO sem criar repositorio
  proprio.
- Se o live ISO deve usar usuario/senha padrao ou autologin.
