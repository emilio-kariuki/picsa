import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:picsa/domain/service/repository/image_repository.dart';

part 'count_state.dart';

class CountCubit extends Cubit<CountState> {
  CountCubit() : super(CountInitial());

  Future<void> getImagesTaken({required String eventId}) async {
    emit(CountLoading());
    final count = await ImageRepository().imagesTaken(eventId: eventId);
    emit(CountLoaded(count: count));
  }
}
