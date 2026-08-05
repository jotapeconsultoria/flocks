import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../../tokens/tokens.dart';

/// Categoria de um anexo — deriva da extensão do arquivo e escolhe o ícone e o
/// tom de cor. Usada por `AppChatAttachmentChip`/`AppChatAttachmentCard` quando
/// não há thumbnail (ou quando o consumidor não passa um ícone).
enum AppAttachmentKind {
  /// Imagens (png/jpg/gif/webp/svg…).
  image,

  /// Vídeos (mp4/mov/mkv…).
  video,

  /// Áudios (mp3/wav/m4a…).
  audio,

  /// PDF.
  pdf,

  /// Planilhas (xls/xlsx/csv).
  spreadsheet,

  /// Apresentações (ppt/pptx).
  presentation,

  /// Documentos de texto (doc/txt/md/rtf).
  document,

  /// Arquivos compactados (zip/rar/7z…).
  archive,

  /// Qualquer outra extensão (fallback).
  file;

  /// Papel de cor do tom do anexo.
  Color color(AppColorTheme t) => switch (this) {
    AppAttachmentKind.image => t.info,
    AppAttachmentKind.video => t.secondary,
    AppAttachmentKind.audio => t.tertiary,
    AppAttachmentKind.pdf => t.danger,
    AppAttachmentKind.spreadsheet => t.success,
    AppAttachmentKind.presentation => t.warning,
    AppAttachmentKind.document => t.info,
    AppAttachmentKind.archive => t.onSurface,
    AppAttachmentKind.file => t.onSurface,
  };

  /// Tom do anexo **resolvido por contraste** sobre a superfície
  /// ([readableStopOn]): o mesmo tom de [color], mas num stop legível em claro/
  /// escuro (a base de `secondary`/`tertiary` é escura demais no tema escuro e o
  /// ícone sumia). `archive`/`file` usam `onSurface`, já legível.
  Color accentOn(AppColorTheme t) => switch (this) {
    AppAttachmentKind.image => readableStopOn(t.info, t.surface),
    AppAttachmentKind.video => readableStopOn(t.secondary, t.surface),
    AppAttachmentKind.audio => readableStopOn(t.tertiary, t.surface),
    AppAttachmentKind.pdf => readableStopOn(t.danger, t.surface),
    AppAttachmentKind.spreadsheet => readableStopOn(t.success, t.surface),
    AppAttachmentKind.presentation => readableStopOn(t.warning, t.surface),
    AppAttachmentKind.document => readableStopOn(t.info, t.surface),
    AppAttachmentKind.archive => t.onSurface,
    AppAttachmentKind.file => t.onSurface,
  };

  /// Ícone padrão da categoria (coarse). Para o glifo mais específico por
  /// extensão, use [appAttachmentIcon].
  String get icon => switch (this) {
    AppAttachmentKind.image => AppIconToken.imageLandscape,
    AppAttachmentKind.video => AppIconToken.videoPlay,
    AppAttachmentKind.audio => AppIconToken.audio,
    AppAttachmentKind.pdf => AppIconToken.filePdf,
    AppAttachmentKind.spreadsheet => AppIconToken.fileXls,
    AppAttachmentKind.presentation => AppIconToken.filePpt,
    AppAttachmentKind.document => AppIconToken.fileText,
    AppAttachmentKind.archive => AppIconToken.zipFile,
    AppAttachmentKind.file => AppIconToken.fileText,
  };

  /// Resolve a categoria a partir do nome/extensão do arquivo.
  static AppAttachmentKind fromFileName(String? name) =>
      _fromExtension(_extension(name));

  static AppAttachmentKind _fromExtension(String ext) {
    if (_imageExts.contains(ext)) return AppAttachmentKind.image;
    if (_videoExts.contains(ext)) return AppAttachmentKind.video;
    if (_audioExts.contains(ext)) return AppAttachmentKind.audio;
    if (ext == 'pdf') return AppAttachmentKind.pdf;
    if (_spreadsheetExts.contains(ext)) return AppAttachmentKind.spreadsheet;
    if (_presentationExts.contains(ext)) return AppAttachmentKind.presentation;
    if (_documentExts.contains(ext)) return AppAttachmentKind.document;
    if (_archiveExts.contains(ext)) return AppAttachmentKind.archive;
    return AppAttachmentKind.file;
  }
}

const Set<String> _imageExts = <String>{
  'png',
  'jpg',
  'jpeg',
  'gif',
  'webp',
  'bmp',
  'svg',
  'heic',
  'heif',
  'avif',
  'tif',
  'tiff',
  'ico',
};
const Set<String> _videoExts = <String>{
  'mp4',
  'mov',
  'avi',
  'mkv',
  'webm',
  'm4v',
  'wmv',
  'flv',
  '3gp',
  'mpeg',
};
const Set<String> _audioExts = <String>{
  'mp3',
  'wav',
  'ogg',
  'm4a',
  'aac',
  'flac',
  'wma',
  'opus',
  'amr',
};
const Set<String> _spreadsheetExts = <String>{'xls', 'xlsx', 'csv', 'ods'};
const Set<String> _presentationExts = <String>{'ppt', 'pptx', 'odp', 'key'};
const Set<String> _documentExts = <String>{
  'doc',
  'docx',
  'txt',
  'rtf',
  'md',
  'odt',
  'pages',
};
const Set<String> _archiveExts = <String>{
  'zip',
  'rar',
  '7z',
  'tar',
  'gz',
  'bz2',
  'xz',
};

/// Ícone **específico por extensão** de um anexo (mais fino que
/// [AppAttachmentKind.icon]): distingue csv, xls, doc, txt, ppt e zip. Cai no
/// ícone da categoria para o resto.
String appAttachmentIcon(String? name, {AppAttachmentKind? kind}) {
  final String ext = _extension(name);
  return switch (ext) {
    'csv' => AppIconToken.csv,
    'xls' || 'xlsx' || 'ods' => AppIconToken.fileXls,
    'pdf' => AppIconToken.filePdf,
    'doc' || 'docx' || 'rtf' || 'odt' => AppIconToken.fileDoc,
    'txt' || 'md' => AppIconToken.fileTxt,
    'ppt' || 'pptx' || 'odp' => AppIconToken.filePpt,
    'zip' || 'rar' || '7z' || 'tar' || 'gz' => AppIconToken.zipFile,
    _ => (kind ?? AppAttachmentKind.fromFileName(name)).icon,
  };
}

String _extension(String? name) {
  if (name == null) return '';
  final int dot = name.lastIndexOf('.');
  if (dot < 0 || dot == name.length - 1) return '';
  return name.substring(dot + 1).toLowerCase();
}
