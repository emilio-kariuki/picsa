import 'package:bloc/bloc.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(const PageState());

  void changePage({required int page}) {
    emit(
      state.copyWith(
        page: page,
        status: PageStatus.changed,
      ),
    );
  }
}

enum PageStatus { initial, changed }

class PageState {
  final int page;
  final PageStatus status;
  const PageState({
    this.page = 0,
    this.status = PageStatus.initial,
  });

  PageState copyWith({
    int? page,
    PageStatus? status,
  }) {
    return PageState(
      page: page ?? this.page,
      status: status ?? this.status,
    );
  }
}
