import 'package:picsa/utilities/packages.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class ImageEditor extends StatelessWidget {
  ImageEditor({super.key, required this.url});

  final String url;

  final _editor = GlobalKey<ProImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProImageEditor.network(
      url,
      key: _editor,
      onImageEditingComplete: (Uint8List bytes) async {
      },
      configs: ProImageEditorConfigs(
        i18n: const I18n(
          various: I18nVarious(),
          paintEditor: I18nPaintingEditor(),
          textEditor: I18nTextEditor(),
          cropRotateEditor: I18nCropRotateEditor(),
          filterEditor: I18nFilterEditor(filters: I18nFilters()),
          emojiEditor: I18nEmojiEditor(),
          // More translations...
        ),
        helperLines: const HelperLines(
          showVerticalLine: true,
          showHorizontalLine: true,
          showRotateLine: true,
          hitVibration: true,
        ),
        imageEditorTheme: const ImageEditorTheme(
          helperLine: HelperLineTheme(
            horizontalColor: Color(0xFF1565C0),
            verticalColor: Color(0xFF1565C0),
            rotateColor: Color(0xFFE91E63),
          ),
          paintingEditor: PaintingEditorTheme(),
          textEditor: TextEditorTheme(),
          cropRotateEditor: CropRotateEditorTheme(),
          filterEditor: FilterEditorTheme(),
          emojiEditor: EmojiEditorTheme(),
          background: Color.fromARGB(255, 22, 22, 22),
          uiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0x42000000),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xFF000000),
          ),
        ),
        icons: const ImageEditorIcons(
          paintingEditor: IconsPaintingEditor(),
          textEditor: IconsTextEditor(),
          cropRotateEditor: IconsCropRotateEditor(),
          filterEditor: IconsFilterEditor(),
          emojiEditor: IconsEmojiEditor(),
          closeEditor: Icons.clear,
          doneIcon: Icons.done,
          applyChanges: Icons.done,
          backButton: Icons.arrow_back,
          undoAction: Icons.undo,
          redoAction: Icons.redo,
          removeElementZone: Icons.delete_outline_rounded,
        ),
        paintEditorConfigs: const PaintEditorConfigs(),
        textEditorConfigs: const TextEditorConfigs(),
        cropRotateEditorConfigs: const CropRotateEditorConfigs(),
        filterEditorConfigs: FilterEditorConfigs(),
        emojiEditorConfigs: const EmojiEditorConfigs(),
        designMode: ImageEditorDesignModeE.material,
        heroTag: 'hero',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade800,
            brightness: Brightness.dark,
          ),
        ),
      ),
    ));
  }
}
