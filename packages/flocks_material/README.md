# flocks_material

Ícones do Material Design como `AppIconProvider` do [Flocks](../flocks).

```yaml
dependencies:
  flocks_material: ^0.1.0
```

```dart
AppThemeScope(
  iconProvider: const MaterialIconProvider(),
  builder: (context, theme) => MyApp(theme: theme),
)
```

## Este pacote existe para provar uma regra

O `flocks` não importa `material.dart`. Não é intenção: há teste de arquitetura
varrendo `lib/src` a cada `flutter test`, e a allow-list tem uma entrada só.

Um adaptador de Material **dentro** do core derrubaria a tese de zero Material
para todo mundo. Aqui fora, quem quiser Material paga por ele e quem não quiser
segue sem — que é exatamente o que um eixo plugável deveria permitir.

## E é a implementação de referência

Um `flocks_fontawesome`, ou o provider do set da sua empresa, tem esta mesma
forma: uma tabela e um `build`. São ~120 linhas no total.

```dart
final class MeuProvider implements AppIconProvider {
  const MeuProvider();

  @override
  Widget build(BuildContext context, String icon,
      {required double size, Color? color}) => /* … */;
}
```

Cobre os 55 de `AppIconToken` — o contrato — e o teste cobra que continue
cobrindo. Nome fora dele cai num interrogação, porque os nomes do Material são
identificadores Dart, não strings: não há como resolver slug arbitrário.

## Licença

MIT, como o Flocks. Os glifos vêm da fonte MaterialIcons que o Flutter embute
(Apache 2.0).
