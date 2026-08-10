# flocks_lucide — exemplo

Uns 20 ícones do Lucide pelos **dois** caminhos que o pacote oferece: os do
contrato, resolvidos por slug pelo provider do tema, e os de fora dele,
escritos direto de `FlocksLucide`.

```bash
flutter run          # ou -d chrome
```

## O harness da medição

Os dois caminhos se comportam de forma diferente no tree-shaking, e medir só um
mentiria: instalar o provider já torna os 55 do contrato alcançáveis, enquanto
uma constante escrita à mão custa só ela.

```bash
flutter build web --release                        # tree-shaking ligado (padrão)
flutter build web --release --no-tree-shake-icons  # controle
du -k build/web/assets/packages/flocks_lucide/assets/fonts/lucide.ttf
```

| | `lucide.ttf` no bundle |
|---|---|
| `--no-tree-shake-icons` | 834 KB |
| padrão | **19 KB** (−97,7%) |

Se esse 19 KB saltar para perto de 834, alguma coisa passou a tornar os 2.025
nomes alcançáveis de uma vez — é essa a regressão que a medição existe para
pegar.
