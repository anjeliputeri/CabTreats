part of 'pick_address_bloc.dart';

@freezed
class PickAddressEvent with _$PickAddressEvent {
  const factory PickAddressEvent.started() = _Started;
  const factory PickAddressEvent.update(double lat, double lng) = _Update;
}