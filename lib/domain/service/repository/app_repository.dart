import 'package:picsa/utilities/packages.dart';

abstract class AppTemplate {
  Future<bool> copyToClipboard({required String text});
  Future<bool> shareContent({required String text, required String subject});
}

class AppRepository extends AppTemplate {
  @override
  Future<bool> copyToClipboard({required String text}) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Error copying to clipboard');
    }
  }

  @override
  Future<bool> shareContent(
      {required String text, required String subject}) async {
    try {
      await Share.share(text, subject: subject);
      return true;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception('Error copying to clipboard');
    }
  }
}
