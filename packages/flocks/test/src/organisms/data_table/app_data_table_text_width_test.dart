import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('o texto da célula mede o TEXTO, não a coluna', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(
            size: Size(1200, 800),
            disableAnimations: true,
          ),
          child: AppTheme(
            data: AppThemeData.light,
            child: AppDataTable(
              columnLabels: const <String>['Documento', 'Nome'],
              columnWidths: const <double>[400, 400],
              rows: const <List<Widget>>[
                <Widget>[AppText('Ok'), AppText('Rastreabrasil')],
              ],
              onPageChange: (_) {},
              onPerPageChange: (_) {},
              page: 1,
              perPage: 16,
              total: 1,
              totalPages: 1,
              totalLabelSingular: 'Conta',
              totalLabelPlural: 'Contas',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // A célula tem 400px de largura; o texto "Ok" ocupa algumas dezenas. Com o
    // `textWidthBasis` padrão (`parent`) o parágrafo media a coluna inteira e o
    // cursor de seleção aparecia em toda a faixa, mesmo longe do texto
    // (revisão P1r9).
    final Size short = tester.getSize(
      find.descendant(of: find.byType(AppDataTable), matching: find.text('Ok')),
    );
    expect(
      short.width,
      lessThan(100),
      reason: 'a caixa do texto curto não pode ocupar a coluna de 400px',
    );

    // E um texto mais longo continua medindo o que ele realmente ocupa.
    final Size longer = tester.getSize(
      find.descendant(
        of: find.byType(AppDataTable),
        matching: find.text('Rastreabrasil'),
      ),
    );
    expect(longer.width, greaterThan(short.width));
    expect(longer.width, lessThan(400));
  });
}
