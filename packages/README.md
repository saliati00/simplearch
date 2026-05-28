# Pacotes Locais

Esta pasta guarda receitas de empacotamento para componentes que nao estao nos
repositorios oficiais do Arch, mas sao necessarios para a ISO.

Pacotes atuais:

- `calamares`: construido a partir de `vendor/calamares-3.4.2.tar.gz`.

Fluxo planejado:

1. Gerar o pacote com `makepkg`.
2. Criar um repositorio pacman local com `repo-add`.
3. Fazer o `archiso` consumir esse repositorio local durante o build.

