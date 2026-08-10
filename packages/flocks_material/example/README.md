# flocks_material — exemplo

Os mesmos dez `AppIconToken` do contrato do Flocks, servidos pelos glifos do
Material.

```bash
flutter run          # ou -d chrome
```

O que o exemplo demonstra é a **troca**, não os desenhos: o `lib/main.dart` não
sabe que existe Material. Quem sabe é uma linha só —

```dart
iconProvider: const MaterialIconProvider(),
```

— e trocá-la por `PhosphorIconProvider()`, do `flocks_phosphor`, redesenha os
dez tokens sem tocar em mais nada da árvore. É o que significa o ícone ser um
eixo do tema e não uma dependência do componente.
