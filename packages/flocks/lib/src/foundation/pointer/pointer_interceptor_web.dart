// Adaptado do `pointer_interceptor_web` 0.10.3 (flutter/packages), sob
// BSD-3-Clause: Copyright 2013 The Flutter Authors. All rights reserved.
// A BSD-3 exige que o aviso de copyright acompanhe a cópia — é o que esta nota
// faz, e o README do pacote a repete onde o leitor a encontra.
import 'dart:js_interop';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Ramo **web** da fachada: reimplementa, dentro do pacote, o que o
/// `pointer_interceptor` fazia no browser.
///
/// **Por que a reimplementação existe.** O `pointer_interceptor` é um plugin
/// federado que endossa só `web` e `ios`. O pana INTERSECTA as declarações de
/// plataforma de todo o fecho de dependências para pontuar um pacote, então
/// aquela única aresta derrubava o `flocks` — e por tabela o `flocks_phosphor`
/// e o `flocks_material` — para "Supports 2 of 6 platforms (iOS, Web)" no
/// pub.dev, num design system que roda em toda parte. Esconder a dependência
/// atrás de import condicional não resolveria nada: o pana lê o `pubspec.yaml`,
/// não o grafo de imports. Só sair do pubspec resolve, e sair implicava trazer
/// estas ~20 linhas para cá.
///
/// **Como funciona.** Um `<div>` vazio é montado como platform view ATRÁS do
/// conteúdo. No engine web toda platform view é um elemento real no DOM, e o
/// clique é evento do browser antes de ser evento do Flutter: quem o recebe é o
/// elemento mais alto na pilha sob o cursor. Um mapa embaixo só engolia o
/// clique porque não havia nada entre ele e o cursor. O `<div>` é esse nada,
/// preenchido.
///
/// **Nenhum view factory é registrado aqui, de propósito.** O
/// `HtmlElementView.fromTagName` resolve para o
/// `defaultInvisibleViewType` — uma factory EMBUTIDA no engine, que lê o
/// `tagName` dos `creationParams`. As versões 0.9.x do plugin registravam a
/// própria factory e precisavam de um guard de "registra uma vez só" mais o
/// `dart:ui_web`; a 0.10 abandonou os dois. Copiar o desenho antigo seria
/// reintroduzir estado global mutável sem ganho nenhum.
///
/// **`isVisible: false`** poupa recurso escasso: o engine fatia o canvas em
/// "overlays" para intercalar HTML entre pixels do Flutter, e o número deles por
/// cena é limitado. Declarar que a view não pinta pixel nenhum economiza um
/// overlay inteiro por card.
///
/// **É wasm-compatível por construção:** `dart:js_interop` + `package:web`,
/// nunca `dart:html`/`dart:js`/`dart:js_util`. É também por isso que a condição
/// da fachada é `dart.library.js_interop` — ver `app_overlay_card.dart`.
Widget interceptPointer(Widget child) => Stack(
  alignment: Alignment.center,
  children: <Widget>[
    // PRIMEIRO na lista = mais ao FUNDO na pilha, e é essa ordem que faz o
    // mecanismo funcionar: o `<div>` precisa ficar atrás do conteúdo Flutter
    // (à frente ele cobriria o próprio card, e ninguém clicaria em nada) e à
    // frente da platform view de baixo. O `Positioned.fill` o cola no rect que
    // o `child` determinou — o `Stack` é `StackFit.loose`, então quem dá o
    // tamanho continua sendo o conteúdo, e o card segue content-sized.
    Positioned.fill(
      child: HtmlElementView.fromTagName(
        tagName: 'div',
        isVisible: false,
        onElementCreated: (Object element) {
          // Cancela o `mousedown`, e não o `click`, porque o que se evita aqui
          // é PERDA DE FOCO: o browser tira o foco do campo em edição no
          // mousedown, antes de qualquer click. Sem isto, clicar na área vazia
          // do card derrubaria o cursor de um `AppInput` dentro dele.
          // Regressão conhecida do upstream (flutter/flutter#157920).
          (element as web.HTMLElement).addEventListener(
            'mousedown',
            (web.Event event) {
              event.preventDefault();
            }.toJS,
          );
        },
      ),
    ),
    child,
  ],
);
