# Jotape — Design Tokens

Referência completa dos tokens da marca **Jotape** no design system **flocks**.
Valores extraídos direto do código (as cores são geradas por HCT a partir das
seeds da marca, então os hex abaixo são os reais em runtime).

- Duas variações de tema: **Light** e **Dark**.
- Escalas de cor (swatches) vão de **50** (mais claro) a **900** (mais escuro).
- "on-color" = cor de conteúdo (texto/ícone) legível sobre a cor base.

Gerado em 2026-07-03.

---

## 1. Espaçamento & Tamanho (`AppSpacings` / `AppSizes`)

Mesma escala numérica para os dois (nome = valor em px).

| Token | px |
|---|---|
| `s0` | 0 |
| `s1` | 1 |
| `s2` | 2 |
| `s4` | 4 |
| `s8` | 8 |
| `s12` | 12 |
| `s16` | 16 |
| `s24` | 24 |
| `s32` | 32 |
| `s48` | 48 |
| `s64` | 64 |
| `s128` | 128 |
| `s192` | 192 |

## 2. Raio de canto (`AppRadius`)

| Token | px |
|---|---|
| `none` | 0 |
| `xs` | 1 |
| `s` | 2 |
| `m` | 4 |
| `l` | 8 |
| `xl` | 16 |

## 3. Espessura de traço (`AppStrokes`)

| Token | px |
|---|---|
| `none` | 0 |
| `xs` | 0.5 |
| `s` | 1 |
| `m` | 2 |
| `l` | 4 |
| `xl` | 8 |

## 4. Tamanhos de ícone e ilustração

**Ícones** (`AppIconSize`): `s` = 16 · `m` = 24 · `l` = 32 · `xl` = 64 px
**Ilustrações** (`AppIllustrationSize`): `s` = 128 · `m` = 192 · `l` = 256 · `xl` = 384 px

## 5. Tipografia (`AppTextStyles`)

Fonte padrão do pacote: **Poppins** em toda a escala. A marca pode trocar a
família de display e a de corpo por [`AppBrandTypography`](lib/src/brand/app_brand_typography.dart)
— a marca `flocks`, por exemplo, usa **Space Grotesk** na display.

| Token | Fonte | Tamanho | Entrelinha | Peso |
|---|---|---|---|---|
| `displayLarge` | Poppins | 57 | 64 | 400 |
| `displayMedium` | Poppins | 45 | 52 | 400 |
| `displaySmall` | Poppins | 36 | 44 | 400 |
| `headlineLarge` | Poppins | 32 | 40 | 500 |
| `headlineMedium` | Poppins | 28 | 36 | 500 |
| `headlineSmall` | Poppins | 24 | 32 | 500 |
| `titleLarge` | Poppins | 22 | 28 | 600 |
| `titleMedium` | Poppins | 16 | 24 | 600 |
| `titleSmall` | Poppins | 14 | 20 | 600 |
| `bodyLarge` | Poppins | 16 | 24 | 400 |
| `bodyMedium` | Poppins | 14 | 20 | 400 |
| `bodySmall` | Poppins | 12 | 16 | 400 |
| `labelLarge` | Poppins | 14 | 20 | 500 |
| `labelMedium` | Poppins | 12 | 16 | 500 |
| `labelSmall` | Poppins | 11 | 16 | 500 |

> Pesos empacotados: 400 (Regular), 500 (Medium) e 600 (SemiBold). A Space
> Grotesk traz 400 e 500 — a display não pede 600.

## 6. Movimento

**Durações** (`AppDurations`): `fast` = 120ms · `normal` = 200ms · `medium` = 260ms · `slow` = 450ms · `loop` = 1200ms · `loopSlow` = 1500ms

**Curvas** (`AppCurves`):
| Token | Curva |
|---|---|
| `standard` | easeInOutCubic |
| `emphasized` | easeOutCubic |
| `decelerate` | easeOut |
| `accelerate` | easeInCubic |
| `emphasizedOvershoot` | cubic-bezier(0.34, 1.56, 0.64, 1.0) |

---

## 7. Cores

### 7.1 Escalas da marca (swatches 50–900)

Cada papel tem uma escala completa. O **valor base** de cada papel (o que
`primary`, `secondary`, etc. usam) está na seção 7.3/7.4 (roles).

**Cores principais**

| Escala | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|---|
| **primary** | `#F2FBFA` | `#D2F5F1` | `#A5EAE3` | `#70D8D2` | `#42BFBB` | `#29A3A1` | `#1E8283` | `#1C6869` | `#1B5254` | `#1A4647` |
| **secondary** | `#FFF6ED` | `#FFEAD4` | `#FFD1A8` | `#FFB070` | `#FF8437` | `#FF5B04` | `#F04706` | `#C73307` | `#9E290E` | `#7F240F` |
| **tertiary** | `#EDFFFD` | `#C3FFFB` | `#87FFF9` | `#42FFFC` | `#0CF1F5` | `#00D2D9` | `#00A5AF` | `#00818A` | `#02656D` | `#075056` |

**Cores semânticas**

| Escala | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|---|
| **danger** | `#FFEDEC` | `#FED8D5` | `#FEB7B2` | `#FD867D` | `#FB1504` | `#D61203` | `#B71306` | `#9B0E03` | `#7E1007` | `#68120B` |
| **info** | `#F0F9FF` | `#E0F2FE` | `#BAE6FD` | `#7DD3FC` | `#38BDF8` | `#0EA5E9` | `#0284C7` | `#0369A1` | `#075985` | `#0C4A6E` |
| **success** | `#F1FCEF` | `#DFF9D9` | `#BEF2B5` | `#8CE57D` | `#48CC33` | `#3DB12B` | `#29841B` | `#226818` | `#1F5218` | `#1A4415` |
| **warning** | `#FFFAE8` | `#FEEFC0` | `#FEDD7B` | `#FDC536` | `#FDAB02` | `#E18404` | `#C76202` | `#A64204` | `#873309` | `#6E2A0B` |

**Neutros** (escala flipa entre Light e Dark)

| Escala | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|---|
| **neutral (Light)** | `#F9FBFB` | `#F3F6F6` | `#E4EBEC` | `#D3DDDE` | `#9AAEB1` | `#697E82` | `#496365` | `#355053` | `#1D3739` | `#0F2529` |
| **neutral (Dark)** | `#0A1E22` | `#0F2529` | `#1D3739` | `#355053` | `#496365` | `#697E82` | `#9AAEB1` | `#D3DDDE` | `#E4EBEC` | `#F3F6F6` |

**On-colors** (conteúdo sobre a cor) — escalas de referência

| Escala | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|---|
| **onPrimary / onTertiary** | `#848484` | `#9C9C9C` | `#B7B7B7` | `#D0D0D0` | `#EAEAEA` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| **onSecondary / onDanger / onInfo / onSuccess / onWarning** | `#7B7B7B` | `#636363` | `#4F4F4F` | `#3B3B3B` | `#1F1F1F` | `#000000` | `#000000` | `#000000` | `#000000` | `#000000` |

**Neutros por opacidade** (preto/branco com alpha — hex `#AARRGGBB`)

| Escala | 50 (10%) | 100 (20%) | 200 (30%) | 300 (40%) | 400 (50%) | 500 (60%) | 600 (70%) | 700 (80%) | 800 (90%) | 900 (100%) |
|---|---|---|---|---|---|---|---|---|---|---|
| **neutralBlack** | `#1A000000` | `#33000000` | `#4D000000` | `#66000000` | `#80000000` | `#99000000` | `#B3000000` | `#CC000000` | `#E6000000` | `#000000` |
| **neutralWhite** | `#1AFFFFFF` | `#33FFFFFF` | `#4DFFFFFF` | `#66FFFFFF` | `#80FFFFFF` | `#99FFFFFF` | `#B3FFFFFF` | `#CCFFFFFF` | `#E6FFFFFF` | `#FFFFFF` |

### 7.2 Papéis de superfície & interface

| Papel | Light | Dark |
|---|---|---|
| `surface` (fundo da página) | `#D1D3D3` | `#0A1E22` |
| `onSurface` (texto sobre a superfície) | `#0F2529` | `#F3F6F6` |
| `surfaceContainer` (card/painel elevado) | `#F9FBFB` | `#44585C` |
| `outline` (borda) | `#496365` | `#697E82` |
| `focusRing` (anel de foco) | `#1C6869` | `#42BFBB` |

### 7.3 Papéis semânticos — Light

| Papel | Base | On-color |
|---|---|---|
| `primary` | `#0C3235` | `#FFFFFF` |
| `secondary` | `#FF5B04` | `#000000` |
| `tertiary` | `#075056` | `#FFFFFF` |
| `danger` | `#FB1504` | `#000000` |
| `info` | `#0EA5E9` | `#000000` |
| `success` | `#48CC33` | `#000000` |
| `warning` | `#FDAB02` | `#000000` |
| `neutralBlack` | `#000000` | — |
| `neutralWhite` | `#FFFFFF` | — |

### 7.4 Papéis semânticos — Dark

O base das cores da marca é o mesmo do Light (a marca mantém o hue); mudam as
superfícies (7.2) e o data-viz (7.5).

| Papel | Base | On-color |
|---|---|---|
| `primary` | `#0C3235` | `#FFFFFF` |
| `secondary` | `#FF5B04` | `#000000` |
| `tertiary` | `#075056` | `#FFFFFF` |
| `danger` | `#FB1504` | `#000000` |
| `info` | `#0EA5E9` | `#000000` |
| `success` | `#48CC33` | `#000000` |
| `warning` | `#FDAB02` | `#000000` |

> Observação: o **base do `primary` é escuro** (`#0C3235`, ~stop 950). Para
> destacar em fundo escuro use um stop claro da escala primary (ex.: `400` =
> `#42BFBB`, que é justo o `focusRing` do Dark).

### 7.5 Data-viz (gráficos / scores)

| Papel | Light | Dark |
|---|---|---|
| `chartGood` | `#3C6A19` | `#7CB342` |
| `chartNeutral` | `#5E5E5E` | `#9E9E9E` |
| `chartBad` | `#904D00` | `#E8A04D` |
| `scoreLow` | `#B62226` | `#EF5350` |
| `scoreMid` | `#765B00` | `#E6C04A` |
| `scoreHigh` | `#3C6A19` | `#7CB342` |

**Paleta categórica** (séries de gráficos, 8 cores)

- Light: `#5B8C5A` · `#E8915A` · `#6B9EC4` · `#D4A843` · `#9B6B9E` · `#CC6666` · `#4DADA8` · `#8B7355`
- Dark: `#7FB07E` · `#F0AB7F` · `#8FBADC` · `#E2C272` · `#BF95C1` · `#DB8F8F` · `#79C9C4` · `#B39B7E`
