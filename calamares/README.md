# Calamares

Esta pasta vai conter a configuracao do instalador Calamares.

Observacao importante: `calamares` nao esta disponivel nos repositorios
oficiais do Arch neste ambiente. O source upstream foi colocado em
`vendor/calamares-3.4.2.tar.gz` e ha um `PKGBUILD` inicial em
`packages/calamares/`.

Para gerar o pacote local:

```bash
./scripts/build-calamares-package.sh
```

Depois disso ainda sera necessario criar um repositorio pacman local e fazer o
`archiso` consumir esse repositorio durante o build.

Escopo inicial:

- `settings.conf`
- modulos de particionamento, locale, usuario, bootloader e pacotes
- escolha simples de driver de video
- chamadas `shellprocess` para ajustes finais em chroot

Status atual:

- A ISO inclui uma configuracao minima em `archiso/airootfs/etc/calamares`.
- Essa configuracao serve para validar que o Calamares abre e que os modulos
  basicos de interface funcionam.
- Ela ainda nao deve ser considerada fluxo de instalacao real, porque nao inclui
  particionamento, unpackfs, bootloader, usuarios nem pos-instalacao.

Locale e timezone:

- O Calamares suporta GeoIP no modulo `locale` para detectar timezone.
- O modulo `welcome` tambem pode usar GeoIP para pre-selecionar idioma com base
  no pais.
- A configuracao inicial deve usar um servico HTTPS de GeoIP, preferencialmente
  o endpoint mantido pelo KDE usado nos exemplos upstream:
  `https://geoip.kde.org/v1/calamares`.
- O instalador ainda deve permitir alteracao manual de idioma, teclado e
  timezone; GeoIP deve ser conveniencia, nao obrigacao.
