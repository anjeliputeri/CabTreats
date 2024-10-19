import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pick_address_event.dart';
part 'pick_address_state.dart';
part 'pick_address_bloc.freezed.dart';


class PickAddressBloc extends Bloc<PickAddressEvent, PickAddressState> {
  PickAddressBloc() : super(const _Loaded(0, 0)) {
    on<_Update>((event, emit) {
      emit(_Loaded(event.lat, event.lng));
    });


  }
}
