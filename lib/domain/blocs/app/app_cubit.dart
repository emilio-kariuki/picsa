import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/repository/repository.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/utilities/packages.dart';

class AppCubit extends Cubit<AppState> {
  final _appProvider = service<AppRepository>();
  AppCubit() : super(AppState());

  Future<void> copyToClipboard({required String text}) async {
    try {
      emit(state.copyWith(
        status: AppStatus.loading,
        message: "Copying to clipboard...",
      ));
      await _appProvider.copyToClipboard(text: text);
      emit(state.copyWith(
        status: AppStatus.success,
        message: "Copied to clipboard",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AppStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> shareContent({required String text, required String subject}) async {
    try {
      emit(state.copyWith(
        status: AppStatus.loading,
        message: "Sharing content...",
      ));
      await _appProvider.shareContent(text: text, subject: subject);
      emit(state.copyWith(
        status: AppStatus.success,
        message: "Shared the content",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AppStatus.error,
        message: error.toString().toException(),
      ));
    }
  }
}

enum AppStatus { initial, loading, success, error }

class AppState {
  final AppStatus status;
  final String message;
  AppState({
    this.status = AppStatus.initial,
    this.message = "",
  });

  AppState copyWith({
    UserModel? user,
    AppStatus status = AppStatus.initial,
    String message = "",
  }) {
    return AppState(
      status: status,
      message: message,
    );
  }
}
