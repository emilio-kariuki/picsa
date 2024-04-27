import 'package:bloc/bloc.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageState());

  void changePage({required int page}) {
    emit(state.copyWith(page: page));
  }
}
