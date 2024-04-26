import 'package:picsa/domain/service/repository/repository.dart';

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
}
