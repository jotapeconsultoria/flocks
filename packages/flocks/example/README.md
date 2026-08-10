# flocks — exemplo

A tese do pacote numa tela só: **uma** semente de cor e **três** eixos globais
restilizando os componentes, sem que nenhum deles receba cor, raio ou sombra por
parâmetro.

```bash
flutter run          # ou -d chrome
```

Os três botões do rodapé alternam os eixos ao vivo — estilo (`filled` ·
`outlined` · `elevated`), forma (`AppRadiusMode`) e brilho. O card e os próprios
botões mudam juntos, porque o eixo é global e não uma propriedade de cada
componente.

Troque o `kSeed` no topo do `lib/main.dart` e a tela inteira troca de marca:
`swatchFromSeed` deriva a escala completa da semente, e claro e escuro saem
ambos dela — não de duas paletas mantidas à mão.

Para a vitrine interativa dos 131 componentes, com knobs por propriedade, veja
[widgetbook.flocks.live](https://widgetbook.flocks.live).
