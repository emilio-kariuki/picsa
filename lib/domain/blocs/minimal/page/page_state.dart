part of 'page_cubit.dart';
class PageState {
  final int page;
  const PageState({this.page = 0});

  PageState copyWith({int? page}) {
    return PageState(page: page ?? this.page);
  }
}
