import 'package:picsa/utilities/packages.dart';

abstract class AppTemplate {
  Future<bool> copyToClipboard({required String text});
  Future<bool> shareContent({required String text, required String subject});
  Future<void> launchBrowser({required String url});
  Future<void> launchPhone({required String phone});
  Future<void> launchEmail({required String email});
  Future<bool> shareImage({required String url});
  Future<bool> downloadImage(
      {required BuildContext context, required String url});
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

  @override
  Future<void> launchBrowser({required String url}) async {
    try {
      final browserUrl = Uri.parse(url);

      await launchUrl(browserUrl,
      mode: LaunchMode.externalApplication,
          webOnlyWindowName: "Privacy & Policy");
    } catch (e) {
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<bool> shareImage({required String url}) async {
    try {
      await Share.shareUri(Uri.parse(url));
      return true;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<bool> downloadImage(
      {required BuildContext context, required String url}) async {
    try {
      final flutterMediaDownloaderPlugin = MediaDownload();
      flutterMediaDownloaderPlugin.downloadMedia(context, url, "Picsa");

      return true;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<void> launchEmail({required String email}) async {
    try {
      final emailUrl = 'mailto:$email';
      await launchUrl(Uri.parse(emailUrl));
    } catch (e) {
      debugPrint('Error launching broswer $e');
    }
  }

  @override
  Future<void> launchPhone({required String phone}) async{
    try {
      final phoneUrl = 'tel:$phone';
      await launchUrl(Uri.parse(phoneUrl));
    } catch (e) {
      debugPrint('Error launching broswer $e');
    }
  }
}
