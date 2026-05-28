# Perfil Archiso

Esta pasta vai conter o perfil `archiso` da ISO do Simple Arch, baseado no
perfil `releng` do Arch Linux.

Arquivos iniciais:

- `profiledef.sh`
- `packages.x86_64`
- `pacman.conf`
- `airootfs/`
- assets e configuracoes do ambiente live

Build local planejado:

```bash
sudo mkarchiso -v -w ~/simplearch-build/work -o ~/simplearch-build/out archiso
```

Observacao: esta primeira versao foi criada antes de instalar o pacote
`archiso` localmente. Quando o pacote estiver disponivel, o perfil deve ser
comparado com `/usr/share/archiso/configs/releng` e ajustado se necessario.
