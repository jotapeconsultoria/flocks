import 'package:flutter/widgets.dart';

import '../../atoms/atoms.dart';
import '../../tokens/tokens.dart';
import 'app_form_wizard_step.dart';

/// Componente wizard que compoe um indicador de passos com paineis de conteudo.
///
/// No desktop, o indicador fica na lateral esquerda (vertical).
/// No mobile, o indicador fica no topo (horizontal) com scroll se necessario.
///
/// Os paineis de conteudo sao carregados com lazy loading e preservados
/// entre navegacoes via `Offstage` + `TickerMode`.
///
/// Este e um widget controlado: `currentStep` deve ser gerenciado externamente
/// (ex: via Cubit).
///
/// Exemplo:
/// ```dart
/// AppFormWizard(
///   currentStep: 0,
///   steps: [
///     AppFormWizardStep(
///       title: 'Dados Basicos',
///       builder: (_) => MyFormFields(),
///     ),
///     AppFormWizardStep(
///       title: 'Configuracoes',
///       builder: (_) => MyConfigFields(),
///     ),
///   ],
/// )
/// ```
final class AppFormWizard extends StatefulWidget {
  const AppFormWizard({
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
    this.showIndicator = true,
    super.key,
  }) : assert(steps.length > 0, 'Pelo menos um passo e obrigatorio'),
       assert(
         currentStep >= 0 && currentStep < steps.length,
         'currentStep deve estar entre 0 e steps.length - 1',
       );

  /// Passo atual (0-indexed). Controlado externamente.
  final int currentStep;

  /// Callback ao tocar em um passo completo no indicador.
  final ValueChanged<int>? onStepTapped;

  /// Se deve exibir o indicador de passos.
  final bool showIndicator;

  /// Passos do wizard.
  final List<AppFormWizardStep> steps;

  @override
  State<AppFormWizard> createState() => _AppFormWizardState();
}

class _AppFormWizardState extends State<AppFormWizard> {
  late final Set<int> _visitedStepIndexes;

  @override
  void initState() {
    super.initState();
    _visitedStepIndexes = <int>{widget.currentStep};
  }

  @override
  void didUpdateWidget(covariant AppFormWizard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.steps.length < oldWidget.steps.length) {
      _visitedStepIndexes.removeWhere((index) => index >= widget.steps.length);
    }

    if (widget.currentStep != oldWidget.currentStep) {
      _visitedStepIndexes.add(widget.currentStep);
    }
  }

  bool _shouldBuildContentFor(int index) {
    return _visitedStepIndexes.contains(index);
  }

  Widget _buildStepContent(int index) {
    // A chave estável preserva o estado local do passo sem congelar
    // dependências externas, como dropdowns carregados de forma assíncrona.
    return KeyedSubtree(
      key: ValueKey('app_form_wizard_content_$index'),
      child: widget.steps[index].builder(context),
    );
  }

  Widget _buildContent() {
    // Passos visitados ficam montados (estado preservado + lazy load), mas só o
    // passo atual é exibido. Usamos Offstage (não pinta, não recebe input, sem
    // layout visível) para garantir que o conteúdo do passo anterior nunca se
    // sobreponha ao atual — independente de animações. TickerMode silencia as
    // animações dos passos ocultos.
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < widget.steps.length; i++)
          if (_shouldBuildContentFor(i))
            Offstage(
              offstage: widget.currentStep != i,
              child: TickerMode(
                enabled: widget.currentStep == i,
                child: _buildStepContent(i),
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= AppDevice.mobile.breakpoint;
        final axis = isMobile ? Axis.horizontal : Axis.vertical;

        if (!widget.showIndicator) {
          return _buildContent();
        }

        final indicator = _buildIndicator(axis);

        if (axis == Axis.vertical) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSpacings.s16,
                  top: AppSpacings.s16 + AppSpacings.s4,
                  right: AppSpacings.s0,
                ),
                child: indicator,
              ),
              Expanded(child: _buildContent()),
            ],
          );
        }

        // Horizontal: calcula largura minima necessaria.
        // Cada step precisa de pelo menos circleSize, e entre eles
        // precisa de minLineLength.
        final stepCount = widget.steps.length;
        final minWidth =
            (stepCount * appStepperCircleSize) +
            ((stepCount - 1) * appStepperMinLineLength) +
            (AppSpacings.s32 * 2); // padding horizontal

        final availableWidth = constraints.maxWidth;

        // Se cabe, renderiza direto (Expanded funciona com bounded width).
        // Se nao cabe, wrappa em scroll com largura fixa minima.
        Widget indicatorWidget;
        if (availableWidth >= minWidth) {
          indicatorWidget = Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.s32,
              AppSpacings.s16,
              AppSpacings.s32,
              AppSpacings.s0,
            ),
            child: indicator,
          );
        } else {
          indicatorWidget = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.s32,
              AppSpacings.s16,
              AppSpacings.s32,
              AppSpacings.s0,
            ),
            child: SizedBox(
              width: minWidth - (AppSpacings.s32 * 2),
              child: indicator,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            indicatorWidget,
            Expanded(child: _buildContent()),
          ],
        );
      },
    );
  }

  Widget _buildIndicator(Axis axis) {
    final stepDataList = widget.steps
        .map(
          (s) =>
              AppStepData(title: s.title, subtitle: s.subtitle, icon: s.icon),
        )
        .toList();

    return AppStepper(
      axis: axis,
      currentStep: widget.currentStep,
      onStepTapped: widget.onStepTapped,
      steps: stepDataList,
    );
  }
}
