# Relatório de Contraste — Marcas Flocks

> Gerado por `test/src/theme/contrast_report_test.dart`. Não editar à mão — rode `flutter test --dart-define=CONTRAST_REPORT=true test/src/theme/contrast_report_test.dart`.

Métrica dupla: **razão WCAG 2** (piso legal) + **ΔT de tom HCT** (perceptual). Alvos e o "porquê" em [`COLOR_ACCESSIBILITY_RULES.md`](COLOR_ACCESSIBILITY_RULES.md).

## flocks · light

`surface` = #D3DAEA · `onSurface` = #1B222E

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #1B222E / #D3DAEA | 11.40 (≥4.5) | 73.9 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #4F46E5 | 6.29 (≥4.5) | 59.3 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #000000 / #E5484D | 5.37 (≥4.5) | 53.8 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #000000 / #E5484D | 5.37 (≥4.5) | 53.8 (≥50) | ✅ |
| `onDanger/danger` | onColor | #000000 / #D84315 | 4.73 (≥4.5) | 50.3 (≥50) | ✅ |
| `onInfo/info` | onColor | #FFFFFF / #0063B2 | 6.13 (≥4.5) | 58.6 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #008F4C | 5.03 (≥4.5) | 52.0 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #FFCB05 | 13.80 (≥4.5) | 84.0 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #585F6C / #D3DAEA | 4.59 (≥3.0) | 46.8 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #3323CC / #D3DAEA | 6.65 (≥3.0) | 56.9 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #F9F9FF / #D3DAEA | 1.34 (≥1.0) | 11.1 (≥11) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #3C6A19 / #D3DAEA | 4.59 (≥3.0) | 46.8 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #5E5E5E / #D3DAEA | 4.63 (≥3.0) | 47.1 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #904D00 / #D3DAEA | 4.61 (≥3.0) | 47.0 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #B62226 / #D3DAEA | 4.62 (≥3.0) | 47.0 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #765B00 / #D3DAEA | 4.59 (≥3.0) | 46.8 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #3C6A19 / #D3DAEA | 4.59 (≥3.0) | 46.8 (≥40) | ✅ |

## flocks · dark

`surface` = #111823 · `onSurface` = #F0F3FF

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #F0F3FF / #111823 | 16.09 (≥4.5) | 87.9 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #4F46E5 | 6.29 (≥4.5) | 59.3 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #000000 / #E5484D | 5.37 (≥4.5) | 53.8 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #000000 / #E5484D | 5.37 (≥4.5) | 53.8 (≥50) | ✅ |
| `onDanger/danger` | onColor | #000000 / #D84315 | 4.73 (≥4.5) | 50.3 (≥50) | ✅ |
| `onInfo/info` | onColor | #FFFFFF / #0063B2 | 6.13 (≥4.5) | 58.6 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #008F4C | 5.03 (≥4.5) | 52.0 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #FFCB05 | 13.80 (≥4.5) | 84.0 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #737A88 / #111823 | 4.13 (≥3.0) | 43.0 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #8582FF / #111823 | 5.63 (≥3.0) | 52.0 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #454C59 / #111823 | 2.06 (≥1.0) | 24.1 (≥22) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #7CB342 / #111823 | 7.11 (≥3.0) | 59.1 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #9E9E9E / #111823 | 6.65 (≥3.0) | 57.0 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #E8A04D / #111823 | 8.12 (≥3.0) | 63.4 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #EF5350 / #111823 | 5.11 (≥3.0) | 49.1 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #E6C04A / #111823 | 10.18 (≥3.0) | 71.0 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #7CB342 / #111823 | 7.11 (≥3.0) | 59.1 (≥40) | ✅ |
| `surface fora do preto puro` | darkSurface | #111823 | T=8.1 | [6.0, 16.0] | ✅ |

## jotape · light

`surface` = #D3DDDE · `onSurface` = #0F2529

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #0F2529 / #D3DDDE | 11.52 (≥4.5) | 74.3 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #0C3235 | 13.79 (≥4.5) | 81.6 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #000000 / #FF5B04 | 6.75 (≥4.5) | 60.6 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #FFFFFF / #075056 | 9.17 (≥4.5) | 69.5 (≥50) | ✅ |
| `onDanger/danger` | onColor | #000000 / #FB1504 | 5.21 (≥4.5) | 53.0 (≥50) | ✅ |
| `onInfo/info` | onColor | #000000 / #0EA5E9 | 7.58 (≥4.5) | 64.1 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #48CC33 | 9.96 (≥4.5) | 72.8 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #FDAB02 | 11.00 (≥4.5) | 76.1 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #496365 / #D3DDDE | 4.66 (≥3.0) | 47.4 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #1C6869 / #D3DDDE | 4.69 (≥3.0) | 47.5 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #F9FBFB / #D3DDDE | 1.33 (≥1.0) | 11.1 (≥11) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #3C6A19 / #D3DDDE | 4.64 (≥3.0) | 47.3 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #5E5E5E / #D3DDDE | 4.68 (≥3.0) | 47.5 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #904D00 / #D3DDDE | 4.67 (≥3.0) | 47.4 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #B62226 / #D3DDDE | 4.67 (≥3.0) | 47.4 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #765B00 / #D3DDDE | 4.64 (≥3.0) | 47.3 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #3C6A19 / #D3DDDE | 4.64 (≥3.0) | 47.3 (≥40) | ✅ |

## jotape · dark

`surface` = #0A1E22 · `onSurface` = #F3F6F6

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #F3F6F6 / #0A1E22 | 15.82 (≥4.5) | 86.8 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #0C3235 | 13.79 (≥4.5) | 81.6 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #000000 / #FF5B04 | 6.75 (≥4.5) | 60.6 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #FFFFFF / #075056 | 9.17 (≥4.5) | 69.5 (≥50) | ✅ |
| `onDanger/danger` | onColor | #000000 / #FB1504 | 5.21 (≥4.5) | 53.0 (≥50) | ✅ |
| `onInfo/info` | onColor | #000000 / #0EA5E9 | 7.58 (≥4.5) | 64.1 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #48CC33 | 9.96 (≥4.5) | 72.8 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #FDAB02 | 11.00 (≥4.5) | 76.1 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #697E82 / #0A1E22 | 4.02 (≥3.0) | 41.4 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #42BFBB / #0A1E22 | 7.70 (≥3.0) | 61.0 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #355053 / #0A1E22 | 1.98 (≥1.0) | 22.2 (≥22) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #7CB342 / #0A1E22 | 6.86 (≥3.0) | 57.4 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #9E9E9E / #0A1E22 | 6.42 (≥3.0) | 55.2 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #E8A04D / #0A1E22 | 7.83 (≥3.0) | 61.6 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #EF5350 / #0A1E22 | 4.93 (≥3.0) | 47.3 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #E6C04A / #0A1E22 | 9.82 (≥3.0) | 69.2 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #7CB342 / #0A1E22 | 6.86 (≥3.0) | 57.4 (≥40) | ✅ |
| `surface fora do preto puro` | darkSurface | #0A1E22 | T=9.9 | [6.0, 16.0] | ✅ |

## zxtrack · light

`surface` = #D3D3D3 · `onSurface` = #1A1A1A

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #1A1A1A / #D3D3D3 | 11.63 (≥4.5) | 75.3 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onDanger/danger` | onColor | #FFFFFF / #EA1521 | 4.54 (≥4.5) | 50.3 (≥50) | ✅ |
| `onInfo/info` | onColor | #000000 / #3B82F6 | 5.71 (≥4.5) | 55.6 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #3CCF30 | 10.16 (≥4.5) | 73.4 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #BA730C | 5.55 (≥4.5) | 54.8 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #575757 / #D3D3D3 | 4.83 (≥3.0) | 47.6 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #AF2A26 / #D3D3D3 | 4.41 (≥3.0) | 45.1 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #FAFAFA / #D3D3D3 | 1.43 (≥1.0) | 13.7 (≥11) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #3C6A19 / #D3D3D3 | 4.29 (≥3.0) | 44.4 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #5E5E5E / #D3D3D3 | 4.33 (≥3.0) | 44.7 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #904D00 / #D3D3D3 | 4.32 (≥3.0) | 44.6 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #B62226 / #D3D3D3 | 4.32 (≥3.0) | 44.6 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #765B00 / #D3D3D3 | 4.29 (≥3.0) | 44.4 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #3C6A19 / #D3D3D3 | 4.29 (≥3.0) | 44.4 (≥40) | ✅ |

## zxtrack · dark

`surface` = #151515 · `onSurface` = #F5F5F5

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #F5F5F5 / #151515 | 16.75 (≥4.5) | 89.8 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onDanger/danger` | onColor | #FFFFFF / #EA1521 | 4.54 (≥4.5) | 50.3 (≥50) | ✅ |
| `onInfo/info` | onColor | #000000 / #3B82F6 | 5.71 (≥4.5) | 55.6 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #3CCF30 | 10.16 (≥4.5) | 73.4 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #BA730C | 5.55 (≥4.5) | 54.8 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #727272 / #151515 | 3.80 (≥3.0) | 41.3 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #EF7E7A / #151515 | 6.90 (≥3.0) | 58.7 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #454545 / #151515 | 1.90 (≥1.0) | 22.5 (≥22) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #7CB342 / #151515 | 7.29 (≥3.0) | 60.4 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #9E9E9E / #151515 | 6.82 (≥3.0) | 58.3 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #E8A04D / #151515 | 8.32 (≥3.0) | 64.7 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #EF5350 / #151515 | 5.24 (≥3.0) | 50.4 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #E6C04A / #151515 | 10.44 (≥3.0) | 72.3 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #7CB342 / #151515 | 7.29 (≥3.0) | 60.4 (≥40) | ✅ |
| `surface fora do preto puro` | darkSurface | #151515 | T=6.8 | [6.0, 16.0] | ✅ |

---

**Resumo:** 0 de 117 verificações AA falham hoje.
