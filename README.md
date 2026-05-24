# Arch Linux Post-Install Script 🚀

Este repositório contém um script Bash robusto, idempotente e seguro para pós-instalação do Arch Linux. Ele automatiza a configuração do sistema, a instalação de softwares essenciais, utilitários de jogos e a montagem automática de partições.

## 🛠️ O que o script faz?

1. **Validações Iniciais**:
   - Impede execução direta como `root` (fundamental para o funcionamento do compilador do AUR).
   - Mantém as credenciais de `sudo` ativas em segundo plano (`keep-alive`) até o fim do script.
   - Testa a conexão de internet enviando uma requisição HTTP para o site do Arch Linux.
   - Rastreia erros e imprime a linha exata caso ocorra alguma falha (`trap ERR`).

2. **Repositório Multilib**:
   - Habilita automaticamente a seção `[multilib]` no `/etc/pacman.conf` se ela estiver desativada, permitindo a instalação do Steam e pacotes de 32 bits.

3. **Shell Moderno (Zsh + Oh My Zsh)**:
   - Instala Zsh, Oh My Zsh e os plugins de sintaxe (`zsh-syntax-highlighting`) e sugestões automáticas (`zsh-autosuggestions`).
   - Configura de forma limpa o tema `duellj` e ativa os plugins no `.zshrc`.
   - Modifica o shell padrão do usuário ativo para o Zsh de forma POSIX (`command -v`).

4. **Gerenciador do AUR (YAY)**:
   - Compila e instala o YAY automaticamente se ele não estiver presente no sistema.

5. **Instalação de Aplicativos**:
   - **Navegador**: Brave Browser (`brave-bin` via AUR).
   - **Jogos**: Steam (nativa) e Flatpak.
   - **Otimização**: GameMode e `lib32-gamemode` para alta performance em jogos.
   - **Integração KDE/Flatpak**: Instala portais XDG para que apps em Flatpak (como o Heroic) abram diálogos nativos do KDE.
   - **Heroic Games Launcher**: Instalado via Flatpak.

6. **Montagem Automática do HDD**:
   - Cria o ponto de montagem em `$HOME/HDD`.
   - Lê o UUID e o tipo de sistema de arquivos do disco (padrão `/dev/sda1`) dinamicamente via `blkid`.
   - Adiciona uma linha de montagem otimizada no `/etc/fstab` com flags de performance (`defaults,nofail,noatime`).
   - Executa a montagem imediata sem duplicar entradas existentes.

---

## 🚀 Como usar na nova instalação

Assim que terminar de instalar seu Arch Linux e logar com seu usuário comum:

### 1. Clonar este repositório
```bash
git clone <URL_DO_SEU_REPOSITORIO>
cd Post-Install
```

### 2. Dar permissão de execução ao script
```bash
chmod +x post-install.sh
```

### 3. Executar o script (como usuário comum)
> ⚠️ **IMPORTANTE**: Não execute com `sudo ./post-install.sh`. Rode como usuário normal. O script solicitará a senha do `sudo` quando necessário.
```bash
./post-install.sh
```

---

## 📝 Personalização
Se você deseja alterar o disco rígido que será montado automaticamente (o padrão é `/dev/sda1`), abra o script `post-install.sh` e altere a variável `TARGET_DEV` no início da **Seção 13**:

```bash
TARGET_DEV="/dev/sdb1" # Altere para o seu disco desejado
```
