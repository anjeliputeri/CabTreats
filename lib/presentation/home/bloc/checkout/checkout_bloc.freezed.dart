// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CheckoutEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutEventCopyWith<$Res> {
  factory $CheckoutEventCopyWith(
          CheckoutEvent value, $Res Function(CheckoutEvent) then) =
      _$CheckoutEventCopyWithImpl<$Res, CheckoutEvent>;
}

/// @nodoc
class _$CheckoutEventCopyWithImpl<$Res, $Val extends CheckoutEvent>
    implements $CheckoutEventCopyWith<$Res> {
  _$CheckoutEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
          _$StartedImpl value, $Res Function(_$StartedImpl) then) =
      __$$StartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl();

  @override
  String toString() {
    return 'CheckoutEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements CheckoutEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$AddItemImplCopyWith<$Res> {
  factory _$$AddItemImplCopyWith(
          _$AddItemImpl value, $Res Function(_$AddItemImpl) then) =
      __$$AddItemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Product product});
}

/// @nodoc
class __$$AddItemImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddItemImpl>
    implements _$$AddItemImplCopyWith<$Res> {
  __$$AddItemImplCopyWithImpl(
      _$AddItemImpl _value, $Res Function(_$AddItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
  }) {
    return _then(_$AddItemImpl(
      null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
    ));
  }
}

/// @nodoc

class _$AddItemImpl implements _AddItem {
  const _$AddItemImpl(this.product);

  @override
  final Product product;

  @override
  String toString() {
    return 'CheckoutEvent.addItem(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddItemImpl &&
            (identical(other.product, product) || other.product == product));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddItemImplCopyWith<_$AddItemImpl> get copyWith =>
      __$$AddItemImplCopyWithImpl<_$AddItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addItem(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addItem?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addItem != null) {
      return addItem(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addItem(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addItem?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addItem != null) {
      return addItem(this);
    }
    return orElse();
  }
}

abstract class _AddItem implements CheckoutEvent {
  const factory _AddItem(final Product product) = _$AddItemImpl;

  Product get product;
  @JsonKey(ignore: true)
  _$$AddItemImplCopyWith<_$AddItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RemoveItemImplCopyWith<$Res> {
  factory _$$RemoveItemImplCopyWith(
          _$RemoveItemImpl value, $Res Function(_$RemoveItemImpl) then) =
      __$$RemoveItemImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Product product});
}

/// @nodoc
class __$$RemoveItemImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$RemoveItemImpl>
    implements _$$RemoveItemImplCopyWith<$Res> {
  __$$RemoveItemImplCopyWithImpl(
      _$RemoveItemImpl _value, $Res Function(_$RemoveItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? product = null,
  }) {
    return _then(_$RemoveItemImpl(
      null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
    ));
  }
}

/// @nodoc

class _$RemoveItemImpl implements _RemoveItem {
  const _$RemoveItemImpl(this.product);

  @override
  final Product product;

  @override
  String toString() {
    return 'CheckoutEvent.removeItem(product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveItemImpl &&
            (identical(other.product, product) || other.product == product));
  }

  @override
  int get hashCode => Object.hash(runtimeType, product);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveItemImplCopyWith<_$RemoveItemImpl> get copyWith =>
      __$$RemoveItemImplCopyWithImpl<_$RemoveItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return removeItem(product);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return removeItem?.call(product);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (removeItem != null) {
      return removeItem(product);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return removeItem(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return removeItem?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (removeItem != null) {
      return removeItem(this);
    }
    return orElse();
  }
}

abstract class _RemoveItem implements CheckoutEvent {
  const factory _RemoveItem(final Product product) = _$RemoveItemImpl;

  Product get product;
  @JsonKey(ignore: true)
  _$$RemoveItemImplCopyWith<_$RemoveItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddAddressIdImplCopyWith<$Res> {
  factory _$$AddAddressIdImplCopyWith(
          _$AddAddressIdImpl value, $Res Function(_$AddAddressIdImpl) then) =
      __$$AddAddressIdImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String addressId});
}

/// @nodoc
class __$$AddAddressIdImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddAddressIdImpl>
    implements _$$AddAddressIdImplCopyWith<$Res> {
  __$$AddAddressIdImplCopyWithImpl(
      _$AddAddressIdImpl _value, $Res Function(_$AddAddressIdImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressId = null,
  }) {
    return _then(_$AddAddressIdImpl(
      null == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddAddressIdImpl implements _AddAddressId {
  const _$AddAddressIdImpl(this.addressId);

  @override
  final String addressId;

  @override
  String toString() {
    return 'CheckoutEvent.addAddressId(addressId: $addressId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddAddressIdImpl &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, addressId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddAddressIdImplCopyWith<_$AddAddressIdImpl> get copyWith =>
      __$$AddAddressIdImplCopyWithImpl<_$AddAddressIdImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addAddressId(addressId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addAddressId?.call(addressId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addAddressId != null) {
      return addAddressId(addressId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addAddressId(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addAddressId?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addAddressId != null) {
      return addAddressId(this);
    }
    return orElse();
  }
}

abstract class _AddAddressId implements CheckoutEvent {
  const factory _AddAddressId(final String addressId) = _$AddAddressIdImpl;

  String get addressId;
  @JsonKey(ignore: true)
  _$$AddAddressIdImplCopyWith<_$AddAddressIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddPaymentMethodImplCopyWith<$Res> {
  factory _$$AddPaymentMethodImplCopyWith(_$AddPaymentMethodImpl value,
          $Res Function(_$AddPaymentMethodImpl) then) =
      __$$AddPaymentMethodImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String paymentMethod});
}

/// @nodoc
class __$$AddPaymentMethodImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddPaymentMethodImpl>
    implements _$$AddPaymentMethodImplCopyWith<$Res> {
  __$$AddPaymentMethodImplCopyWithImpl(_$AddPaymentMethodImpl _value,
      $Res Function(_$AddPaymentMethodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethod = null,
  }) {
    return _then(_$AddPaymentMethodImpl(
      null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddPaymentMethodImpl implements _AddPaymentMethod {
  const _$AddPaymentMethodImpl(this.paymentMethod);

  @override
  final String paymentMethod;

  @override
  String toString() {
    return 'CheckoutEvent.addPaymentMethod(paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPaymentMethodImpl &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @override
  int get hashCode => Object.hash(runtimeType, paymentMethod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPaymentMethodImplCopyWith<_$AddPaymentMethodImpl> get copyWith =>
      __$$AddPaymentMethodImplCopyWithImpl<_$AddPaymentMethodImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addPaymentMethod(paymentMethod);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addPaymentMethod?.call(paymentMethod);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addPaymentMethod != null) {
      return addPaymentMethod(paymentMethod);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addPaymentMethod(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addPaymentMethod?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addPaymentMethod != null) {
      return addPaymentMethod(this);
    }
    return orElse();
  }
}

abstract class _AddPaymentMethod implements CheckoutEvent {
  const factory _AddPaymentMethod(final String paymentMethod) =
      _$AddPaymentMethodImpl;

  String get paymentMethod;
  @JsonKey(ignore: true)
  _$$AddPaymentMethodImplCopyWith<_$AddPaymentMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddShippingServiceImplCopyWith<$Res> {
  factory _$$AddShippingServiceImplCopyWith(_$AddShippingServiceImpl value,
          $Res Function(_$AddShippingServiceImpl) then) =
      __$$AddShippingServiceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String shippingService, int shippingCost});
}

/// @nodoc
class __$$AddShippingServiceImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddShippingServiceImpl>
    implements _$$AddShippingServiceImplCopyWith<$Res> {
  __$$AddShippingServiceImplCopyWithImpl(_$AddShippingServiceImpl _value,
      $Res Function(_$AddShippingServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingService = null,
    Object? shippingCost = null,
  }) {
    return _then(_$AddShippingServiceImpl(
      null == shippingService
          ? _value.shippingService
          : shippingService // ignore: cast_nullable_to_non_nullable
              as String,
      null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AddShippingServiceImpl implements _AddShippingService {
  const _$AddShippingServiceImpl(this.shippingService, this.shippingCost);

  @override
  final String shippingService;
  @override
  final int shippingCost;

  @override
  String toString() {
    return 'CheckoutEvent.addShippingService(shippingService: $shippingService, shippingCost: $shippingCost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddShippingServiceImpl &&
            (identical(other.shippingService, shippingService) ||
                other.shippingService == shippingService) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost));
  }

  @override
  int get hashCode => Object.hash(runtimeType, shippingService, shippingCost);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddShippingServiceImplCopyWith<_$AddShippingServiceImpl> get copyWith =>
      __$$AddShippingServiceImplCopyWithImpl<_$AddShippingServiceImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addShippingService(shippingService, shippingCost);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addShippingService?.call(shippingService, shippingCost);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addShippingService != null) {
      return addShippingService(shippingService, shippingCost);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addShippingService(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addShippingService?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addShippingService != null) {
      return addShippingService(this);
    }
    return orElse();
  }
}

abstract class _AddShippingService implements CheckoutEvent {
  const factory _AddShippingService(
          final String shippingService, final int shippingCost) =
      _$AddShippingServiceImpl;

  String get shippingService;
  int get shippingCost;
  @JsonKey(ignore: true)
  _$$AddShippingServiceImplCopyWith<_$AddShippingServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddSubTotalPriceImplCopyWith<$Res> {
  factory _$$AddSubTotalPriceImplCopyWith(_$AddSubTotalPriceImpl value,
          $Res Function(_$AddSubTotalPriceImpl) then) =
      __$$AddSubTotalPriceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int subtotal});
}

/// @nodoc
class __$$AddSubTotalPriceImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddSubTotalPriceImpl>
    implements _$$AddSubTotalPriceImplCopyWith<$Res> {
  __$$AddSubTotalPriceImplCopyWithImpl(_$AddSubTotalPriceImpl _value,
      $Res Function(_$AddSubTotalPriceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
  }) {
    return _then(_$AddSubTotalPriceImpl(
      null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AddSubTotalPriceImpl implements _AddSubTotalPrice {
  const _$AddSubTotalPriceImpl(this.subtotal);

  @override
  final int subtotal;

  @override
  String toString() {
    return 'CheckoutEvent.addSubTotalPrice(subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddSubTotalPriceImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subtotal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddSubTotalPriceImplCopyWith<_$AddSubTotalPriceImpl> get copyWith =>
      __$$AddSubTotalPriceImplCopyWithImpl<_$AddSubTotalPriceImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addSubTotalPrice(subtotal);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addSubTotalPrice?.call(subtotal);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addSubTotalPrice != null) {
      return addSubTotalPrice(subtotal);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addSubTotalPrice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addSubTotalPrice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addSubTotalPrice != null) {
      return addSubTotalPrice(this);
    }
    return orElse();
  }
}

abstract class _AddSubTotalPrice implements CheckoutEvent {
  const factory _AddSubTotalPrice(final int subtotal) = _$AddSubTotalPriceImpl;

  int get subtotal;
  @JsonKey(ignore: true)
  _$$AddSubTotalPriceImplCopyWith<_$AddSubTotalPriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddDeliveryMethodImplCopyWith<$Res> {
  factory _$$AddDeliveryMethodImplCopyWith(_$AddDeliveryMethodImpl value,
          $Res Function(_$AddDeliveryMethodImpl) then) =
      __$$AddDeliveryMethodImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String deliveryMethod});
}

/// @nodoc
class __$$AddDeliveryMethodImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddDeliveryMethodImpl>
    implements _$$AddDeliveryMethodImplCopyWith<$Res> {
  __$$AddDeliveryMethodImplCopyWithImpl(_$AddDeliveryMethodImpl _value,
      $Res Function(_$AddDeliveryMethodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryMethod = null,
  }) {
    return _then(_$AddDeliveryMethodImpl(
      null == deliveryMethod
          ? _value.deliveryMethod
          : deliveryMethod // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddDeliveryMethodImpl implements _AddDeliveryMethod {
  const _$AddDeliveryMethodImpl(this.deliveryMethod);

  @override
  final String deliveryMethod;

  @override
  String toString() {
    return 'CheckoutEvent.addDeliveryMethod(deliveryMethod: $deliveryMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddDeliveryMethodImpl &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod));
  }

  @override
  int get hashCode => Object.hash(runtimeType, deliveryMethod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddDeliveryMethodImplCopyWith<_$AddDeliveryMethodImpl> get copyWith =>
      __$$AddDeliveryMethodImplCopyWithImpl<_$AddDeliveryMethodImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addDeliveryMethod(deliveryMethod);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addDeliveryMethod?.call(deliveryMethod);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addDeliveryMethod != null) {
      return addDeliveryMethod(deliveryMethod);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addDeliveryMethod(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addDeliveryMethod?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addDeliveryMethod != null) {
      return addDeliveryMethod(this);
    }
    return orElse();
  }
}

abstract class _AddDeliveryMethod implements CheckoutEvent {
  const factory _AddDeliveryMethod(final String deliveryMethod) =
      _$AddDeliveryMethodImpl;

  String get deliveryMethod;
  @JsonKey(ignore: true)
  _$$AddDeliveryMethodImplCopyWith<_$AddDeliveryMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SubmitOrderImplCopyWith<$Res> {
  factory _$$SubmitOrderImplCopyWith(
          _$SubmitOrderImpl value, $Res Function(_$SubmitOrderImpl) then) =
      __$$SubmitOrderImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SubmitOrderImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$SubmitOrderImpl>
    implements _$$SubmitOrderImplCopyWith<$Res> {
  __$$SubmitOrderImplCopyWithImpl(
      _$SubmitOrderImpl _value, $Res Function(_$SubmitOrderImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SubmitOrderImpl implements _SubmitOrder {
  const _$SubmitOrderImpl();

  @override
  String toString() {
    return 'CheckoutEvent.submitOrder()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SubmitOrderImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return submitOrder();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return submitOrder?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (submitOrder != null) {
      return submitOrder();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return submitOrder(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return submitOrder?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (submitOrder != null) {
      return submitOrder(this);
    }
    return orElse();
  }
}

abstract class _SubmitOrder implements CheckoutEvent {
  const factory _SubmitOrder() = _$SubmitOrderImpl;
}

/// @nodoc
abstract class _$$AddOriginalSubTotalPriceImplCopyWith<$Res> {
  factory _$$AddOriginalSubTotalPriceImplCopyWith(
          _$AddOriginalSubTotalPriceImpl value,
          $Res Function(_$AddOriginalSubTotalPriceImpl) then) =
      __$$AddOriginalSubTotalPriceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int subtotal});
}

/// @nodoc
class __$$AddOriginalSubTotalPriceImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddOriginalSubTotalPriceImpl>
    implements _$$AddOriginalSubTotalPriceImplCopyWith<$Res> {
  __$$AddOriginalSubTotalPriceImplCopyWithImpl(
      _$AddOriginalSubTotalPriceImpl _value,
      $Res Function(_$AddOriginalSubTotalPriceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtotal = null,
  }) {
    return _then(_$AddOriginalSubTotalPriceImpl(
      null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AddOriginalSubTotalPriceImpl implements _AddOriginalSubTotalPrice {
  const _$AddOriginalSubTotalPriceImpl(this.subtotal);

  @override
  final int subtotal;

  @override
  String toString() {
    return 'CheckoutEvent.addOriginalSubTotalPrice(subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddOriginalSubTotalPriceImpl &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, subtotal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddOriginalSubTotalPriceImplCopyWith<_$AddOriginalSubTotalPriceImpl>
      get copyWith => __$$AddOriginalSubTotalPriceImplCopyWithImpl<
          _$AddOriginalSubTotalPriceImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addOriginalSubTotalPrice(subtotal);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addOriginalSubTotalPrice?.call(subtotal);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addOriginalSubTotalPrice != null) {
      return addOriginalSubTotalPrice(subtotal);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addOriginalSubTotalPrice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addOriginalSubTotalPrice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addOriginalSubTotalPrice != null) {
      return addOriginalSubTotalPrice(this);
    }
    return orElse();
  }
}

abstract class _AddOriginalSubTotalPrice implements CheckoutEvent {
  const factory _AddOriginalSubTotalPrice(final int subtotal) =
      _$AddOriginalSubTotalPriceImpl;

  int get subtotal;
  @JsonKey(ignore: true)
  _$$AddOriginalSubTotalPriceImplCopyWith<_$AddOriginalSubTotalPriceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddOrderTimeImplCopyWith<$Res> {
  factory _$$AddOrderTimeImplCopyWith(
          _$AddOrderTimeImpl value, $Res Function(_$AddOrderTimeImpl) then) =
      __$$AddOrderTimeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String orderTime});
}

/// @nodoc
class __$$AddOrderTimeImplCopyWithImpl<$Res>
    extends _$CheckoutEventCopyWithImpl<$Res, _$AddOrderTimeImpl>
    implements _$$AddOrderTimeImplCopyWith<$Res> {
  __$$AddOrderTimeImplCopyWithImpl(
      _$AddOrderTimeImpl _value, $Res Function(_$AddOrderTimeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderTime = null,
  }) {
    return _then(_$AddOrderTimeImpl(
      null == orderTime
          ? _value.orderTime
          : orderTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddOrderTimeImpl implements _AddOrderTime {
  const _$AddOrderTimeImpl(this.orderTime);

  @override
  final String orderTime;

  @override
  String toString() {
    return 'CheckoutEvent.addOrderTime(orderTime: $orderTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddOrderTimeImpl &&
            (identical(other.orderTime, orderTime) ||
                other.orderTime == orderTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddOrderTimeImplCopyWith<_$AddOrderTimeImpl> get copyWith =>
      __$$AddOrderTimeImplCopyWithImpl<_$AddOrderTimeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Product product) addItem,
    required TResult Function(Product product) removeItem,
    required TResult Function(String addressId) addAddressId,
    required TResult Function(String paymentMethod) addPaymentMethod,
    required TResult Function(String shippingService, int shippingCost)
        addShippingService,
    required TResult Function(int subtotal) addSubTotalPrice,
    required TResult Function(String deliveryMethod) addDeliveryMethod,
    required TResult Function() submitOrder,
    required TResult Function(int subtotal) addOriginalSubTotalPrice,
    required TResult Function(String orderTime) addOrderTime,
  }) {
    return addOrderTime(orderTime);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(Product product)? addItem,
    TResult? Function(Product product)? removeItem,
    TResult? Function(String addressId)? addAddressId,
    TResult? Function(String paymentMethod)? addPaymentMethod,
    TResult? Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult? Function(int subtotal)? addSubTotalPrice,
    TResult? Function(String deliveryMethod)? addDeliveryMethod,
    TResult? Function()? submitOrder,
    TResult? Function(int subtotal)? addOriginalSubTotalPrice,
    TResult? Function(String orderTime)? addOrderTime,
  }) {
    return addOrderTime?.call(orderTime);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Product product)? addItem,
    TResult Function(Product product)? removeItem,
    TResult Function(String addressId)? addAddressId,
    TResult Function(String paymentMethod)? addPaymentMethod,
    TResult Function(String shippingService, int shippingCost)?
        addShippingService,
    TResult Function(int subtotal)? addSubTotalPrice,
    TResult Function(String deliveryMethod)? addDeliveryMethod,
    TResult Function()? submitOrder,
    TResult Function(int subtotal)? addOriginalSubTotalPrice,
    TResult Function(String orderTime)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addOrderTime != null) {
      return addOrderTime(orderTime);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddItem value) addItem,
    required TResult Function(_RemoveItem value) removeItem,
    required TResult Function(_AddAddressId value) addAddressId,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddShippingService value) addShippingService,
    required TResult Function(_AddSubTotalPrice value) addSubTotalPrice,
    required TResult Function(_AddDeliveryMethod value) addDeliveryMethod,
    required TResult Function(_SubmitOrder value) submitOrder,
    required TResult Function(_AddOriginalSubTotalPrice value)
        addOriginalSubTotalPrice,
    required TResult Function(_AddOrderTime value) addOrderTime,
  }) {
    return addOrderTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddItem value)? addItem,
    TResult? Function(_RemoveItem value)? removeItem,
    TResult? Function(_AddAddressId value)? addAddressId,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddShippingService value)? addShippingService,
    TResult? Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult? Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult? Function(_SubmitOrder value)? submitOrder,
    TResult? Function(_AddOriginalSubTotalPrice value)?
        addOriginalSubTotalPrice,
    TResult? Function(_AddOrderTime value)? addOrderTime,
  }) {
    return addOrderTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddItem value)? addItem,
    TResult Function(_RemoveItem value)? removeItem,
    TResult Function(_AddAddressId value)? addAddressId,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddShippingService value)? addShippingService,
    TResult Function(_AddSubTotalPrice value)? addSubTotalPrice,
    TResult Function(_AddDeliveryMethod value)? addDeliveryMethod,
    TResult Function(_SubmitOrder value)? submitOrder,
    TResult Function(_AddOriginalSubTotalPrice value)? addOriginalSubTotalPrice,
    TResult Function(_AddOrderTime value)? addOrderTime,
    required TResult orElse(),
  }) {
    if (addOrderTime != null) {
      return addOrderTime(this);
    }
    return orElse();
  }
}

abstract class _AddOrderTime implements CheckoutEvent {
  const factory _AddOrderTime(final String orderTime) = _$AddOrderTimeImpl;

  String get orderTime;
  @JsonKey(ignore: true)
  _$$AddOrderTimeImplCopyWith<_$AddOrderTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CheckoutState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutStateCopyWith<$Res> {
  factory $CheckoutStateCopyWith(
          CheckoutState value, $Res Function(CheckoutState) then) =
      _$CheckoutStateCopyWithImpl<$Res, CheckoutState>;
}

/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res, $Val extends CheckoutState>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'CheckoutState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)
        loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements CheckoutState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'CheckoutState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements CheckoutState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<ProductQuantity> products,
      String addressId,
      String paymentMethod,
      String shippingService,
      int shippingCost,
      String paymentVaName,
      int subTotalPrice,
      String deliveryMethod,
      int oriSubTotalPrice,
      String orderTime});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? addressId = null,
    Object? paymentMethod = null,
    Object? shippingService = null,
    Object? shippingCost = null,
    Object? paymentVaName = null,
    Object? subTotalPrice = null,
    Object? deliveryMethod = null,
    Object? oriSubTotalPrice = null,
    Object? orderTime = null,
  }) {
    return _then(_$LoadedImpl(
      null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductQuantity>,
      null == addressId
          ? _value.addressId
          : addressId // ignore: cast_nullable_to_non_nullable
              as String,
      null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      null == shippingService
          ? _value.shippingService
          : shippingService // ignore: cast_nullable_to_non_nullable
              as String,
      null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int,
      null == paymentVaName
          ? _value.paymentVaName
          : paymentVaName // ignore: cast_nullable_to_non_nullable
              as String,
      null == subTotalPrice
          ? _value.subTotalPrice
          : subTotalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      null == deliveryMethod
          ? _value.deliveryMethod
          : deliveryMethod // ignore: cast_nullable_to_non_nullable
              as String,
      null == oriSubTotalPrice
          ? _value.oriSubTotalPrice
          : oriSubTotalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      null == orderTime
          ? _value.orderTime
          : orderTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(
      final List<ProductQuantity> products,
      this.addressId,
      this.paymentMethod,
      this.shippingService,
      this.shippingCost,
      this.paymentVaName,
      this.subTotalPrice,
      this.deliveryMethod,
      this.oriSubTotalPrice,
      this.orderTime)
      : _products = products;

  final List<ProductQuantity> _products;
  @override
  List<ProductQuantity> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final String addressId;
  @override
  final String paymentMethod;
  @override
  final String shippingService;
  @override
  final int shippingCost;
  @override
  final String paymentVaName;
  @override
  final int subTotalPrice;
  @override
  final String deliveryMethod;
  @override
  final int oriSubTotalPrice;
  @override
  final String orderTime;

  @override
  String toString() {
    return 'CheckoutState.loaded(products: $products, addressId: $addressId, paymentMethod: $paymentMethod, shippingService: $shippingService, shippingCost: $shippingCost, paymentVaName: $paymentVaName, subTotalPrice: $subTotalPrice, deliveryMethod: $deliveryMethod, oriSubTotalPrice: $oriSubTotalPrice, orderTime: $orderTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.shippingService, shippingService) ||
                other.shippingService == shippingService) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.paymentVaName, paymentVaName) ||
                other.paymentVaName == paymentVaName) &&
            (identical(other.subTotalPrice, subTotalPrice) ||
                other.subTotalPrice == subTotalPrice) &&
            (identical(other.deliveryMethod, deliveryMethod) ||
                other.deliveryMethod == deliveryMethod) &&
            (identical(other.oriSubTotalPrice, oriSubTotalPrice) ||
                other.oriSubTotalPrice == oriSubTotalPrice) &&
            (identical(other.orderTime, orderTime) ||
                other.orderTime == orderTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      addressId,
      paymentMethod,
      shippingService,
      shippingCost,
      paymentVaName,
      subTotalPrice,
      deliveryMethod,
      oriSubTotalPrice,
      orderTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
        products,
        addressId,
        paymentMethod,
        shippingService,
        shippingCost,
        paymentVaName,
        subTotalPrice,
        deliveryMethod,
        oriSubTotalPrice,
        orderTime);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
        products,
        addressId,
        paymentMethod,
        shippingService,
        shippingCost,
        paymentVaName,
        subTotalPrice,
        deliveryMethod,
        oriSubTotalPrice,
        orderTime);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
          products,
          addressId,
          paymentMethod,
          shippingService,
          shippingCost,
          paymentVaName,
          subTotalPrice,
          deliveryMethod,
          oriSubTotalPrice,
          orderTime);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements CheckoutState {
  const factory _Loaded(
      final List<ProductQuantity> products,
      final String addressId,
      final String paymentMethod,
      final String shippingService,
      final int shippingCost,
      final String paymentVaName,
      final int subTotalPrice,
      final String deliveryMethod,
      final int oriSubTotalPrice,
      final String orderTime) = _$LoadedImpl;

  List<ProductQuantity> get products;
  String get addressId;
  String get paymentMethod;
  String get shippingService;
  int get shippingCost;
  String get paymentVaName;
  int get subTotalPrice;
  String get deliveryMethod;
  int get oriSubTotalPrice;
  String get orderTime;
  @JsonKey(ignore: true)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'CheckoutState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ProductQuantity> products,
            String addressId,
            String paymentMethod,
            String shippingService,
            int shippingCost,
            String paymentVaName,
            int subTotalPrice,
            String deliveryMethod,
            int oriSubTotalPrice,
            String orderTime)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements CheckoutState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
