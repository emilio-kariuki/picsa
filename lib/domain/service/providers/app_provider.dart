import 'package:picsa/domain/service/repository/repository.dart';
import 'package:picsa/utilities/packages.dart';

class AppProvider extends AppTemplate {
  final AppRepository _appRepository;
  AppProvider({required AppRepository appRepository})
      : _appRepository = appRepository;

  @override
  Future<bool> copyToClipboard({required String text}) {
    return _appRepository.copyToClipboard(text: text);
  }

  @override
  Future<bool> shareContent({required String text, required String subject}) {
    return _appRepository.shareContent(text: text, subject: subject);
  }

  @override
  Future<void> launchBrowser({required String url}) {
    return _appRepository.launchBrowser(url: url);
  }

  @override
  Future<bool> shareImage({required String url}) {
    return _appRepository.shareImage(url: url);
  }

  @override
  Future<bool> downloadImage({required BuildContext context,required String url}) {
    return _appRepository.downloadImage(context: context,url: url);
  }
  
  @override
  Future<void> launchEmail({required String email}) {
   return _appRepository.launchEmail(email: email);
  }
  
  @override
  Future<void> launchPhone({required String phone}) {
    return _appRepository.launchPhone(phone: phone);
  }
  
  @override
  Future<bool> saveImage({required Uint8List bytes}) {
    return _appRepository.saveImage(bytes: bytes);
  }
}
