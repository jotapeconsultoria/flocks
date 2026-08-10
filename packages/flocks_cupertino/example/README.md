# flocks_cupertino — exemplo

Os mesmos dez `AppIconToken` do contrato do Flocks, servidos pelos glifos do
`cupertino_icons`.

```bash
flutter run          # ou -d chrome
```

O que o exemplo demonstra é a **troca**, não os desenhos: o `lib/main.dart` não
sabe que existe Cupertino. Quem sabe é uma linha só —

```dart
iconProvider: const CupertinoIconProvider(),
```

— e trocá-la por `MaterialIconProvider()` ou `LucideIconProvider()` redesenha os
dez tokens sem tocar em mais nada da árvore. É o que significa o ícone ser um
eixo do tema e não uma dependência do componente.
