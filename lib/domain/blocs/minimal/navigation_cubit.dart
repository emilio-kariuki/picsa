import 'package:equatable/equatable.dart';
import 'package:picsa/utilities/packages.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void changePage({required int page}) {
    emit(state.copyWith(page: page, status: NaviagtionStatus.loaded, message: "navigation has changed"));
  }
}

//* navigations state

enum NaviagtionStatus { initial, loaded, error }

class NavigationState extends Equatable {
  final int page;
  final NaviagtionStatus status;
  final String message;

  const NavigationState(
      {this.page = 0,
      this.status = NaviagtionStatus.initial,
      this.message = ""});

  NavigationState copyWith({
    int? page,
    NaviagtionStatus? status,
    String? message,
  }) {
    return NavigationState(
      page: page ?? this.page,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [page, ];
}
