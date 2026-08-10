import 'package:flutter/widgets.dart';

/// Ramo **default** da fachada de interceptação: devolve o [child] intocado.
///
/// Não é degradação — é o que o `pointer_interceptor` já fazia em toda
/// plataforma que não fosse web ou iOS. O `DefaultPointerInterceptor` do
/// platform interface dele era literalmente `return child;`, porque fora do
/// browser não existe DOM entre o Flutter e a platform view: o hit test do
/// framework resolve a sobreposição sozinho, e interceptar seria custo sem
/// contrapartida.
///
/// Este ramo é o que a VM escolhe, portanto o que TODO widget test e todo
/// golden exercitam. Devolver a **mesma instância**, e não um wrapper, é
/// contrato: `app_overlay_card_test.dart` procura um `DecoratedBox` único como
/// descendente, e os goldens do card foram gravados sem nada no meio.
Widget interceptPointer(Widget child) => child;
