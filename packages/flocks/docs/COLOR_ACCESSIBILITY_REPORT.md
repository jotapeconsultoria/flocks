# Relatório de Contraste — Marcas Flocks

> Gerado por `test/src/theme/contrast_report_test.dart`. Não editar à mão — rode `flutter test --dart-define=CONTRAST_REPORT=true test/src/theme/contrast_report_test.dart`.

Métrica dupla: **razão WCAG 2** (piso legal) + **ΔT de tom HCT** (perceptual). Alvos e o "porquê" em [`COLOR_ACCESSIBILITY_RULES.md`](COLOR_ACCESSIBILITY_RULES.md).

## jotape · light

`surface` = #D1D3D3 · `onSurface` = #0F2529

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #0F2529 / #D1D3D3 | 10.61 (≥4.5) | 71.3 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #0C3235 | 13.79 (≥4.5) | 81.6 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #000000 / #FF5B04 | 6.75 (≥4.5) | 60.6 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #FFFFFF / #075056 | 9.17 (≥4.5) | 69.5 (≥50) | ✅ |
| `onDanger/danger` | onColor | #000000 / #FB1504 | 5.21 (≥4.5) | 53.0 (≥50) | ✅ |
| `onInfo/info` | onColor | #000000 / #0EA5E9 | 7.58 (≥4.5) | 64.1 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #48CC33 | 9.96 (≥4.5) | 72.8 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #FDAB02 | 11.00 (≥4.5) | 76.1 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #496365 / #D1D3D3 | 4.29 (≥3.0) | 44.4 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #1C6869 / #D1D3D3 | 4.32 (≥3.0) | 44.5 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #F9FBFB / #D1D3D3 | 1.45 (≥1.0) | 14.1 (≥12) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #3C6A19 / #D1D3D3 | 4.27 (≥3.0) | 44.3 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #5E5E5E / #D1D3D3 | 4.31 (≥3.0) | 44.5 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #904D00 / #D1D3D3 | 4.30 (≥3.0) | 44.4 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #B62226 / #D1D3D3 | 4.30 (≥3.0) | 44.4 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #765B00 / #D1D3D3 | 4.28 (≥3.0) | 44.3 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #3C6A19 / #D1D3D3 | 4.27 (≥3.0) | 44.3 (≥40) | ✅ |

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
| `surfaceContainer/surface` | separation | #44585C / #0A1E22 | 2.29 (≥1.0) | 26.1 (≥24) | ✅ |
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

`surface` = #D2D2D2 · `onSurface` = #1A1A1A

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #1A1A1A / #D2D2D2 | 11.51 (≥4.5) | 74.9 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onDanger/danger` | onColor | #FFFFFF / #EA1521 | 4.54 (≥4.5) | 50.3 (≥50) | ✅ |
| `onInfo/info` | onColor | #000000 / #3B82F6 | 5.71 (≥4.5) | 55.6 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #3CCF30 | 10.16 (≥4.5) | 73.4 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #BA730C | 5.55 (≥4.5) | 54.8 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #575757 / #D2D2D2 | 4.78 (≥3.0) | 47.2 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #AF2A26 / #D2D2D2 | 4.37 (≥3.0) | 44.8 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #FAFAFA / #D2D2D2 | 1.45 (≥1.0) | 14.1 (≥12) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #3C6A19 / #D2D2D2 | 4.25 (≥3.0) | 44.1 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #5E5E5E / #D2D2D2 | 4.29 (≥3.0) | 44.3 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #904D00 / #D2D2D2 | 4.28 (≥3.0) | 44.2 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #B62226 / #D2D2D2 | 4.28 (≥3.0) | 44.2 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #765B00 / #D2D2D2 | 4.25 (≥3.0) | 44.1 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #3C6A19 / #D2D2D2 | 4.25 (≥3.0) | 44.1 (≥40) | ✅ |

## zxtrack · dark

`surface` = #161616 · `onSurface` = #F5F5F5

| Regra | Tier | fg / bg | Razão (alvo) | ΔT (alvo) | AA |
|---|---|---|---|---|:--:|
| `onSurface/surface` | text | #F5F5F5 / #161616 | 16.60 (≥4.5) | 89.3 (≥50) | ✅ |
| `onPrimary/primary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onSecondary/secondary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onTertiary/tertiary` | onColor | #FFFFFF / #D03530 | 4.96 (≥4.5) | 52.8 (≥50) | ✅ |
| `onDanger/danger` | onColor | #FFFFFF / #EA1521 | 4.54 (≥4.5) | 50.3 (≥50) | ✅ |
| `onInfo/info` | onColor | #000000 / #3B82F6 | 5.71 (≥4.5) | 55.6 (≥50) | ✅ |
| `onSuccess/success` | onColor | #000000 / #3CCF30 | 10.16 (≥4.5) | 73.4 (≥50) | ✅ |
| `onWarning/warning` | onColor | #000000 / #BA730C | 5.55 (≥4.5) | 54.8 (≥50) | ✅ |
| `border(outline)/surface` | uiComponent | #727272 / #161616 | 3.76 (≥3.0) | 40.8 (≥40) | ✅ |
| `focusRing/surface` | uiComponent | #EF7E7A / #161616 | 6.84 (≥3.0) | 58.2 (≥40) | ✅ |
| `surfaceContainer/surface` | separation | #4F4E4E / #161616 | 2.18 (≥1.0) | 26.0 (≥24) | ✅ |
| `onNeutralBlack/neutralBlack` | onColor | #FFFFFF / #000000 | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `onNeutralWhite/neutralWhite` | onColor | #000000 / #FFFFFF | 21.00 (≥4.5) | 100.0 (≥50) | ✅ |
| `chartGood/surface` | uiComponent | #7CB342 / #161616 | 7.22 (≥3.0) | 60.0 (≥40) | ✅ |
| `chartNeutral/surface` | uiComponent | #9E9E9E / #161616 | 6.75 (≥3.0) | 57.9 (≥40) | ✅ |
| `chartBad/surface` | uiComponent | #E8A04D / #161616 | 8.24 (≥3.0) | 64.2 (≥40) | ✅ |
| `scoreLow/surface` | uiComponent | #EF5350 / #161616 | 5.19 (≥3.0) | 49.9 (≥40) | ✅ |
| `scoreMid/surface` | uiComponent | #E6C04A / #161616 | 10.34 (≥3.0) | 71.8 (≥40) | ✅ |
| `scoreHigh/surface` | uiComponent | #7CB342 / #161616 | 7.22 (≥3.0) | 60.0 (≥40) | ✅ |
| `surface fora do preto puro` | darkSurface | #161616 | T=7.2 | [6.0, 16.0] | ✅ |

---

**Resumo:** 0 de 78 verificações AA falham hoje.
