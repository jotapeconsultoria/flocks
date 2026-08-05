# flocks_phosphor — exemplo

Um app com ~20 ícones, pelos dois caminhos do pacote: os `AppIconToken` pelo
provider do tema, e ícones de fora do contrato escritos direto da classe do
peso (incluindo `duotone`, com o caso de camada única).

É também o harness com que o ganho foi medido:

```bash
flutter build web --release                        # tree-shaking ligado (padrão)
flutter build web --release --no-tree-shake-icons  # controle
ls -l build/web/assets/packages/flocks_phosphor/assets/fonts/
```

| | as seis fontes |
|---|---|
| `--no-tree-shake-icons` | 3.001 KB |
| padrão | 91 KB |

Vale medir também trocando o provider para `weight: PhosphorWeight.duotone`: é
o peso que já embarcou a fonte sem nenhum glifo do contrato. Hoje sai com 106
glifos (53 desenhos × 2 camadas); se voltar a 4, a regressão é essa.
