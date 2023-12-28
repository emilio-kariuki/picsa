import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:picsa/domain/models/events_model.dart';
import 'package:picsa/domain/service/repository/event_repository.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());

  Future<void> createEvent({required String name}) async {
    try {
      emit(EventLoading());
      final response = await EventRepository().createEvent(name: name);
      response
          ? emit(EventCreated())
          : emit(const EventError(message: 'Error creating event'));
    } catch (e) {
      emit(EventError(message: e.toString()));
    }
  }

  Future<void> getEvents()async{
    try {
      emit(EventLoading());
      final response = await EventRepository().getUserEvents();
      emit(EventSuccess(events: response));
    } catch (e) {
      emit(EventError(message: e.toString()));
    }
  }
}
