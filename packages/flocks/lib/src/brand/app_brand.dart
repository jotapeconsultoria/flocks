// coverage:ignore-file

import 'dart:developer' as developer;

import 'app_brand_config.dart';
import 'brands/flocks_brand.dart';
import 'brands/jotape_brand.dart';
import 'brands/zxtrack_brand.dart';

/// Registry estatico da marca atual do app.
///
/// Funciona de forma analoga ao [AppEnvironment]: deve ser inicializado
/// no `main()` antes de qualquer uso, e o cliente e selecionado em
/// tempo de compilacao via `--dart-define=CLIENT=<slug>`.
///
/// Resolve slug → **tema**, e so isso. Nome do app, site e assets sao outra
/// pergunta sobre o mesmo app, respondida por outro registry — ver
/// [AppBrandConfig] sobre por que os dois se separaram.
///
/// Para adicionar um novo cliente:
///   1. Criar o arquivo em `brands/<cliente>_brand.dart`
///   2. Registra-lo no mapa [_brands] abaixo
///   3. Buildar com `flutter run --dart-define=CLIENT=<slug>`
abstract final class AppBrand {
  static AppBrandConfig? _current;

  /// Valor bruto recebido via dart-define (util para debug).
  static String? _rawClientSlug;

  /// Mapa de todas as marcas registradas, indexadas pelo slug.
  ///
  /// `final`, não `const`: a marca `flocks` deriva a paleta inteira de uma
  /// semente por `swatchFromSeed`, que é função de runtime. O mapa é montado
  /// uma vez no primeiro acesso — para um registry de leitura, é o mesmo custo.
  static final Map<String, AppBrandConfig> _brands = <String, AppBrandConfig>{
    'flocks': flocksBrand,
    'jotape': jotapeBrand,
    'zxtrack': zxtrackBrand,
  };

  /// Marca padrao usada quando o slug informado nao existe ou nao foi
  /// passado via dart-define.
  static const AppBrandConfig _fallback = jotapeBrand;

  /// Marca atual. Usa fallback se [init] nao foi chamado.
  static AppBrandConfig get current => _current ?? _fallback;

  /// Slug recebido via dart-define. Null se [init] nao foi chamado.
  static String? get rawClientSlug => _rawClientSlug;

  /// Inicializa a marca a partir do dart-define `CLIENT`.
  static void init() {
    const clientSlug = String.fromEnvironment('CLIENT', defaultValue: '');
    _rawClientSlug = clientSlug;

    if (clientSlug.isEmpty) {
      developer.log(
        'AppBrand: dart-define CLIENT nao definido, usando fallback "${_fallback.clientSlug}"',
        name: 'AppBrand',
      );
      _current = _fallback;
      return;
    }

    final brand = _brands[clientSlug];
    if (brand == null) {
      developer.log(
        'AppBrand: cliente "$clientSlug" nao registrado em _brands. '
        'Disponiveis: ${_brands.keys.join(", ")}. Usando fallback "${_fallback.clientSlug}"',
        name: 'AppBrand',
        level: 900, // warning
      );
      _current = _fallback;
      return;
    }

    _current = brand;
    developer.log(
      'AppBrand: inicializado com cliente "${brand.clientSlug}"',
      name: 'AppBrand',
    );
  }

  /// Define a marca manualmente (util para testes).
  static void setBrand(AppBrandConfig brand) => _current = brand;

  /// Lista de slugs de marcas disponiveis.
  static List<String> get availableBrands => _brands.keys.toList();
}
