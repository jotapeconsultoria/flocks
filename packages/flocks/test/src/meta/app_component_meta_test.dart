import 'package:flocks/meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toJson serializa enums como nome e omite campos vazios', () {
    const meta = AppComponentMeta(
      id: 'app_fill_button',
      name: 'AppButton',
      category: ComponentCategory.molecule,
      status: ComponentStatus.migrated,
      summary: LocalizedText(
        en: 'Filled primary action button.',
        pt: 'Botão preenchido de ação primária.',
      ),
      since: 'flocks@0.3.0',
      whenToUse: LocalizedList(
        en: <String>['A prominent CTA'],
        pt: <String>['CTA de destaque'],
      ),
      props: <PropMeta>[
        PropMeta(name: 'onPressed', type: 'VoidCallback?', isRequired: true),
      ],
      examples: <CodeExample>[
        CodeExample(
          title: LocalizedText(en: 'Label', pt: 'Label'),
          code: "AppButton(label: 'Ok')",
        ),
      ],
      a11y: LocalizedText(
        en: 'Exposes semanticsLabel; keyboard-activatable.',
        pt: 'Expõe semanticsLabel; ativável por teclado.',
      ),
      crossPlatform: true,
      themeAware: true,
      reducesMotion: true,
    );

    final json = meta.toJson();

    expect(json['id'], 'app_fill_button');
    expect(json['category'], 'molecule');
    expect(json['status'], 'migrated');
    expect(json['themeAware'], true);
    expect(json['crossPlatform'], true);
    expect((json['props'] as List).first, <String, Object?>{
      'name': 'onPressed',
      'type': 'VoidCallback?',
      'required': true,
    });
    expect(json['examples'], isA<List<Object?>>());
    // Campos vazios são omitidos.
    expect(json.containsKey('variants'), isFalse);
    expect(json.containsKey('dont'), isFalse);
  });

  test('todo texto localizado sai como um par en/pt no JSON', () {
    // A forma aninhada é o contrato com o site: ele lê `campo[locale]` para
    // compor a rota de cada idioma. Achatar para uma língua só aqui quebraria
    // as 129 rotas do outro idioma sem quebrar nenhum teste de Dart — daí este.
    const meta = AppComponentMeta(
      id: 'app_x',
      name: 'AppX',
      category: ComponentCategory.atom,
      status: ComponentStatus.migrated,
      summary: LocalizedText(en: 'Summary.', pt: 'Resumo.'),
      whenToUse: LocalizedList(en: <String>['Use'], pt: <String>['Use']),
      dos: LocalizedList(en: <String>['Do'], pt: <String>['Faça']),
      a11y: LocalizedText(en: 'Labelled.', pt: 'Rotulado.'),
    );

    final json = meta.toJson();

    expect(json['summary'], <String, Object?>{
      'en': 'Summary.',
      'pt': 'Resumo.',
    });
    expect(json['a11y'], <String, Object?>{
      'en': 'Labelled.',
      'pt': 'Rotulado.',
    });
    expect(json['do'], <String, Object?>{
      'en': <String>['Do'],
      'pt': <String>['Faça'],
    });
  });

  test('catálogo contém os componentes migrados', () {
    expect(flocksCatalog.map((m) => m.id), contains('app_text'));
  });
}
