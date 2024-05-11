import 'package:picsa/domain/blocs/app/app_cubit.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class ImageEditor extends StatelessWidget {
  ImageEditor({super.key, required this.url});

  final String url;

  final _editor = GlobalKey<ProImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => AppCubit(),
      child: Builder(builder: (context) {
        return BlocListener<AppCubit, AppState>(
          listener: (context, state) {
            if (state.status == AppStatus.success) {
              context.showSuccessToast(
                  title: "Success", message: state.message, context: context);
            }

            if (state.status == AppStatus.error) {
              context.showErrorToast(
                  title: "Error", message: state.message, context: context);
            }
          },
          child: Stack(
            fit: StackFit.loose,
            children: [
              ProImageEditor.network(
                url,
                key: _editor,
                onImageEditingComplete: (Uint8List bytes) => context.read<AppCubit>().saveImage(
                  bytes: bytes,
                ),
                configs: ProImageEditorConfigs(
                  i18n: const I18n(
                    various: I18nVarious(),
                    paintEditor: I18nPaintingEditor(),
                    textEditor: I18nTextEditor(),
                    cropRotateEditor: I18nCropRotateEditor(),
                    filterEditor: I18nFilterEditor(filters: I18nFilters()),
                    emojiEditor: I18nEmojiEditor(),
                  ),
                  helperLines: const HelperLines(
                    showVerticalLine: true,
                    showHorizontalLine: true,
                    showRotateLine: true,
                    hitVibration: true,
                  ),
                  imageEditorTheme: ImageEditorTheme(
                    editorMode: ThemeEditorMode.whatsapp,
                    appBarForegroundColor: Colors.grey[400]!,
                    appBarBackgroundColor: const Color(0xff212121),
                    bottomBarBackgroundColor: const Color(0xff212121),
                    helperLine: const HelperLineTheme(
                      horizontalColor: Color(0xFF1565C0),
                      verticalColor: Color(0xFF1565C0),
                      rotateColor: Color(0xFFE91E63),
                    ),
                    paintingEditor: PaintingEditorTheme(
                      appBarBackgroundColor: const Color(0xff212121),
                      appBarForegroundColor: Colors.grey[400]!,
                      bottomBarColor: const Color(0xff212121),
                      background: const Color(0xff212121),
                    ),
                    textEditor: TextEditorTheme(
                      appBarBackgroundColor: const Color(0xff212121),
                      appBarForegroundColor: Colors.grey[400]!,
                      background: const Color(0xff212121),
                      inputHintColor: Colors.grey[400]!,
                    ),
                    cropRotateEditor: CropRotateEditorTheme(
                      appBarBackgroundColor: const Color(0xff212121),
                      appBarForegroundColor: Colors.grey[400]!,
                      background: const Color(0xff212121),
                    ),
                    filterEditor: FilterEditorTheme(
                      appBarBackgroundColor: const Color(0xff212121),
                      appBarForegroundColor: Colors.grey[400]!,
                      background: const Color(0xff212121),
                    ),
                    emojiEditor: const EmojiEditorTheme(),
                    background: const Color(0xff212121),
                    uiOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Color(0xff1E1E1E),
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.dark,
                      systemNavigationBarColor: Color(0xff1E1E1E),
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
                  filterEditorConfigs: const FilterEditorConfigs(),
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
              ),
              
            ],
          ),
        );
      }),
    ));
  }
}
