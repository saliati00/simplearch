#!/usr/bin/env bash

# Parar o script imediatamente se qualquer comando falhar, variável for nula ou pipe quebrar
set -euo pipefail

# Inicializa variáveis para o modo set -u
SUDO_PID=""

# Configurações de cores para o terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem Cor

# Funções auxiliares para log formatado
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

log_err() {
    echo -e "${RED}[ERRO]${NC} $1"
}

# Rastreamento de erros
trap 'log_err "O script falhou na linha $LINENO."' ERR

echo "=================================================="
echo " Começando a Pós-Instalação do Arch Linux"
echo "=================================================="

# 1. Verificações de Segurança e Pré-requisitos
# 1.1 Impedir execução direta como root
if [ "$EUID" -eq 0 ]; then
    log_err "Não execute este script diretamente como root (com sudo). Execute como usuário normal."
    exit 1
fi

# 1.2 Verificar conexão com a internet
log_info "Verificando conexão com a internet..."
if ! curl -Is https://archlinux.org >/dev/null; then
    log_err "Sem conexão com a internet. Verifique sua rede antes de prosseguir."
    exit 1
fi

# 1.3 Solicitar privilégios sudo no início e manter a sessão ativa
log_info "Solicitando privilégios de administrador (sudo)..."
sudo -v
# Mantém a sessão sudo ativa em segundo plano durante a execução
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_PID=$!
trap 'kill ${SUDO_PID:-} 2>/dev/null || true' EXIT

# 2. Ativar o repositório [multilib] se necessário
if grep -q "^\[multilib\]" /etc/pacman.conf; then
    log_info "Repositório [multilib] já está ativo."
else
    log_info "Ativando repositório [multilib] no /etc/pacman.conf..."
    # Descomenta a seção [multilib] e a linha Include logo após ela
    sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
    log_info "Sincronizando base de dados do Pacman..."
    sudo pacman -Syu --noconfirm
fi

# 3. Instalar dependências iniciais, Go e Zsh via Pacman
log_info "Instalando base-devel, git, go e zsh via Pacman..."
sudo pacman -S --needed --noconfirm base-devel git go zsh

# 4. Configurar o Oh My Zsh de forma silenciosa e idempotente
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Instalando Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log_warn "Oh My Zsh já está instalado."
fi

# 5. Baixar os plugins de Cores/Sintaxe e Sugestões do Zsh
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
log_info "Instalando plugins de sintaxe e autosuggestions..."

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
else
    log_warn "Plugin zsh-syntax-highlighting já está clonado."
fi

if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
else
    log_warn "Plugin zsh-autosuggestions já está clonado."
fi

# 6. Configurar o tema Duellj e ativar os plugins no .zshrc
if [ -f "$HOME/.zshrc" ]; then
    log_info "Configurando o tema Duellj e os plugins no .zshrc..."
    
    # Atualiza o tema se o padrão ainda estiver configurado
    if grep -q 'ZSH_THEME="robbyrussell"' "$HOME/.zshrc"; then
        sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="duellj"/' "$HOME/.zshrc"
        log_info "Tema alterado para 'duellj' no .zshrc."
    elif grep -q 'ZSH_THEME="duellj"' "$HOME/.zshrc"; then
        log_info "Tema 'duellj' já está configurado."
    else
        log_warn "Tema padrão 'robbyrussell' não foi encontrado no seu .zshrc. Adicionando configuração do duellj ao fim do arquivo."
        echo 'ZSH_THEME="duellj"' >> "$HOME/.zshrc"
    fi

    # Atualiza a lista de plugins se ainda não estiverem configurados
    if grep -q 'zsh-syntax-highlighting' "$HOME/.zshrc" && grep -q 'zsh-autosuggestions' "$HOME/.zshrc"; then
        log_info "Plugins Zsh já parecem configurados no seu .zshrc."
    elif grep -q '^plugins=' "$HOME/.zshrc"; then
        sed -i '/^plugins=/ s/)/ zsh-syntax-highlighting zsh-autosuggestions)/' "$HOME/.zshrc"
        log_info "Plugins zsh-syntax-highlighting e zsh-autosuggestions ativados."
    else
        log_warn "Linha 'plugins=' não encontrada no seu .zshrc. Certifique-se de adicionar os plugins manualmente."
    fi
else
    log_err "Arquivo .zshrc não foi encontrado. Você pode precisar criá-lo ou rodar o instalador do Oh My Zsh novamente."
fi

# 7. Mudar o Shell Padrão do usuário para o Zsh
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
ZSH_PATH=$(command -v zsh)

if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
    log_info "Definindo o Zsh como Shell padrão..."
    sudo chsh -s "$ZSH_PATH" "$USER"
else
    log_info "O Zsh já é o seu shell padrão."
fi

# 8. Instalar o YAY se não estiver presente
if ! command -v yay &> /dev/null; then
    log_info "YAY não encontrado. Iniciando instalação a partir do AUR..."
    # Cria uma pasta temporária segura dentro da pasta do usuário para a compilação
    TEMP_DIR=$(mktemp -d "$HOME/yay-build-XXXXXX")
    
    log_info "Clonando o repositório do YAY do AUR..."
    git clone https://aur.archlinux.org/yay.git "$TEMP_DIR/yay"
    
    cd "$TEMP_DIR/yay"
    log_info "Compilando e instalando o YAY..."
    makepkg -si --noconfirm
    
    cd "$HOME"
    rm -rf "$TEMP_DIR"
    log_info "YAY instalado com sucesso!"
else
    log_info "YAY já está instalado no sistema. Pulando compilação."
fi

echo "=================================================="
log_info "YAY configurado! Iniciando instalação de aplicativos..."
echo "=================================================="

# 9. Instalar o Brave Browser via AUR (YAY)
log_info "Instalando Brave Browser..."
yay -S --needed --noconfirm brave-bin

# 10. Instalar a Steam nativa, Flatpak, GameMode e Portais de Comunicação (KDE) via Pacman
log_info "Instalando Steam, Flatpak, GameMode, lib32-gamemode e portais XDG..."
PACOTES_PACMAN=(
    steam
    flatpak
    gamemode
    lib32-gamemode
    xdg-desktop-portal
    xdg-desktop-portal-kde
)
sudo pacman -S --needed --noconfirm "${PACOTES_PACMAN[@]}"

# 11. Configurar o repositório Flathub
log_info "Adicionando o repositório Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 12. Instalar o Heroic Games Launcher via Flatpak
log_info "Instalando Heroic Games Launcher via Flatpak..."
flatpak install -y flathub com.heroicgameslauncher.hgl

# 13. Configurar a montagem automática do HDD (/etc/fstab)
log_info "Configurando a montagem automática do HDD..."
TARGET_DEV="/dev/sda1"
HDD_MOUNT="$HOME/HDD"
HDD_UUID=""
HDD_FSTYPE=""
if [ ! -d "$HDD_MOUNT" ]; then
    log_info "Criando o diretório de montagem $HDD_MOUNT..."
    mkdir -p "$HDD_MOUNT"
fi

# Tenta obter o UUID e o tipo de partição (FSTYPE) para maior segurança contra mudança de nomes (/dev/sdX)
if [ -b "$TARGET_DEV" ]; then
    HDD_UUID=$(sudo blkid -s UUID -o value "$TARGET_DEV" 2>/dev/null || true)
    HDD_FSTYPE=$(sudo blkid -s TYPE -o value "$TARGET_DEV" 2>/dev/null || true)
    
    if [ -n "$HDD_UUID" ] && [ -n "$HDD_FSTYPE" ]; then
        HDD_IDENTIFIER="UUID=$HDD_UUID"
    else
        log_warn "Não foi possível obter os dados do UUID/FSTYPE de $TARGET_DEV via blkid. Usando valores padrão."
        HDD_IDENTIFIER="$TARGET_DEV"
        HDD_FSTYPE="btrfs"
    fi
else
    log_warn "Dispositivo $TARGET_DEV não encontrado no momento. Usando caminho padrão do dispositivo."
    HDD_IDENTIFIER="$TARGET_DEV"
    HDD_FSTYPE="btrfs"
fi

# Verifica se o HDD já está configurado no /etc/fstab
if grep -q "$HDD_MOUNT" /etc/fstab || grep -q "$TARGET_DEV" /etc/fstab || { [ -n "$HDD_UUID" ] && grep -q "$HDD_UUID" /etc/fstab; }; then
    log_warn "O HDD ($HDD_MOUNT ou $TARGET_DEV) já está configurado no /etc/fstab."
else
    log_info "Adicionando a entrada do HDD ao /etc/fstab..."
    # Adiciona a linha de forma segura usando sudo bash -c para evitar problemas com pipes e tee
    sudo bash -c "echo \"$HDD_IDENTIFIER                                   $HDD_MOUNT   $HDD_FSTYPE   defaults,nofail,noatime 0 2\" >> /etc/fstab"
    log_info "Entrada adicionada com sucesso. Tentando montar..."
    sudo mount -a
fi

echo "=================================================="
log_info "Configuração concluída com sucesso!"
log_info "Reinicie o sistema ou a sessão do terminal para aplicar o shell padrão."
echo "=================================================="
