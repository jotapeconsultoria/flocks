# Ilustrações embutidas

O que o Flocks desenha sem tocar a rede. Hoje é **uma**: `empty`, a única
`AppIllustration` que o próprio design system usa em runtime.

## Procedência

[Open Peeps](https://www.openpeeps.com), de Pablo Stanley, sob **CC0 1.0
Universal** — domínio público, sem atribuição exigida e **sem cláusula de
packs**. Isso importa: unDraw, ManyPixels e Storyset proíbem, com a mesma
frase, "distribute the assets in packs or otherwise", o que é exatamente
embutir num pacote. CC0 não proíbe nada.

| arquivo | origem |
|---|---|
| `empty.svg` | Open Peeps · `Templates/Standing/peep-standing-24.svg` |

## O formato, e por que a conversão é mecânica

O `AppIllustrationColorMapper` pinta por `id`: path com `id` começando em
`baseColor` recebe a tinta, em `accentColor` recebe o preenchimento. O arquivo
não carrega cor nenhuma — é isso que faz a ilustração seguir o tema.

O Open Peeps já vem com **duas camadas nomeadas** em todos os 189 templates,
`🖍-Ink` e `🎨-Background`, que mapeiam 1:1 nesse par. Converter é:

1. tirar o `<?xml?>`, os comentários do Sketch e `<title>`/`<desc>`;
2. `id="🖍-Ink"` → `id="baseColor"`, `id="🎨-Background"` → `id="accentColor"`
   (com sufixo `_2`, `_3`… porque `id` é único no documento);
3. remover `fill="#000000"` e `fill="#FFFFFF"` — quem pinta é o mapper;
4. quadrar o `viewBox` no maior lado e centralizar o conteúdo num `<g>`.

Para acrescentar uma ilustração, repita isso e some o token em
`AppIllustrationToken`.
