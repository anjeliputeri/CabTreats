part of 'pick_address_bloc.dart';

@freezed
class PickAddressState with _$PickAddressState {
  const factory PickAddressState.initial() = _Initial;
  const factory PickAddressState.loading() = _Loading;
  const factory PickAddressState.loaded(double lat, double lng) = _Loaded;
  const factory PickAddressState.error() = _Error;
}
