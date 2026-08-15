import 'dart:typed_data';

import 'package:flocks/flocks.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'wb_helpers.dart';

// 8x8 opaque PNG (74 bytes) — the same canonical sample used by the golden and
// the native previews (duplicated: lib/ and test/ cannot import each other).
const String _kSamplePngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAEUlEQVR42mNgYGD4TwCPBAUAgkg/wZV0VGcAAAAASUVORK5CYII=';

// ---------------------------------------------------------------------------
// AppImage — Playground (all knobs). Static image; no CTA.
// ---------------------------------------------------------------------------

@widgetbook.UseCase(name: 'Playground', type: AppImage)
Widget appImagePlayground(BuildContext context) {
  final url = context.knobs.string(
    label: 'url',
    initialValue: 'https://picsum.photos/320/200',
  );
  final fit = context.knobs.object.dropdown<BoxFit>(
    label: 'fit',
    options: BoxFit.values,
    initialOption: BoxFit.cover,
    labelBuilder: (f) => 'BoxFit.${f.name}',
  );
  final radius = wbRadiusKnob(context, label: 'radius', initial: AppRadius.m);
  final loading = context.knobs.object.dropdown<AppImageLoading>(
    label: 'loading',
    options: AppImageLoading.values,
    initialOption: AppImageLoading.spinner,
    labelBuilder: (l) => 'AppImageLoading.${l.name}',
  );

  return wbUseCase(
    context,
    name: 'AppImage',
    description: 'Raster image with loading + fallback (falls back offline).',
    child: AppImage.network(
      url,
      width: 320,
      height: 200,
      fit: fit,
      radius: BorderRadius.circular(radius),
      loading: loading,
      semanticLabel: 'Sample image',
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: AppImage)
Widget appImageStates(BuildContext context) => wbUseCase(
  context,
  name: 'AppImage',
  description:
      'Loading, error (falls back instead of showing a broken frame) and the '
      'fit modes. The network is blocked here, so every remote source lands on '
      'the fallback — which is exactly the state worth seeing: the layout must '
      'not shift when the image never arrives.',
  maxWidth: 720,
  panelPadding: AppSpacings.s32,
  child: Wrap(
    alignment: WrapAlignment.center,
    spacing: AppSpacings.s24,
    runSpacing: AppSpacings.s24,
    children: [
      wbState(
        context,
        name: 'fallback (bad source)',
        width: 160,
        child: const AppImage.network(
          'https://example.invalid/a.png',
          width: 120,
          height: 90,
        ),
      ),
      wbState(
        context,
        name: 'custom fallback',
        width: 160,
        child: const AppImage.network(
          'https://example.invalid/b.png',
          width: 120,
          height: 90,
          fallback: Center(child: AppText('sem foto')),
        ),
      ),
      wbState(
        context,
        name: 'rounded',
        width: 160,
        child: AppImage.network(
          'https://example.invalid/c.png',
          width: 120,
          height: 90,
          radius: BorderRadius.circular(AppRadius.l),
        ),
      ),
      wbState(
        context,
        name: 'loading: skeleton',
        width: 160,
        child: const AppImage.network(
          'https://example.invalid/photo.png',
          width: 120,
          height: 90,
          loading: AppImageLoading.skeleton,
        ),
      ),
      wbState(
        context,
        name: 'memory (base64)',
        width: 160,
        child: AppImage.memory(
          AppImage.decodeBase64(_kSamplePngBase64)!,
          width: 120,
          height: 90,
          semanticLabel: 'Sample bytes',
        ),
      ),
      wbState(
        context,
        name: 'memory (corrupt bytes)',
        width: 160,
        child: AppImage.memory(
          Uint8List.fromList(const <int>[1, 2, 3]),
          width: 120,
          height: 90,
        ),
      ),
    ],
  ),
);
