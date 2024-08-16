// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrient_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SrLegacyNutrientModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  num get amount => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;

  /// Create a copy of SrLegacyNutrientModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SrLegacyNutrientModelCopyWith<SrLegacyNutrientModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SrLegacyNutrientModelCopyWith<$Res> {
  factory $SrLegacyNutrientModelCopyWith(SrLegacyNutrientModel value,
          $Res Function(SrLegacyNutrientModel) then) =
      _$SrLegacyNutrientModelCopyWithImpl<$Res, SrLegacyNutrientModel>;
  @useResult
  $Res call({int id, String name, num amount, String unit});
}

/// @nodoc
class _$SrLegacyNutrientModelCopyWithImpl<$Res,
        $Val extends SrLegacyNutrientModel>
    implements $SrLegacyNutrientModelCopyWith<$Res> {
  _$SrLegacyNutrientModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SrLegacyNutrientModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? unit = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SrLegacyNutrientModelImplCopyWith<$Res>
    implements $SrLegacyNutrientModelCopyWith<$Res> {
  factory _$$SrLegacyNutrientModelImplCopyWith(
          _$SrLegacyNutrientModelImpl value,
          $Res Function(_$SrLegacyNutrientModelImpl) then) =
      __$$SrLegacyNutrientModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, num amount, String unit});
}

/// @nodoc
class __$$SrLegacyNutrientModelImplCopyWithImpl<$Res>
    extends _$SrLegacyNutrientModelCopyWithImpl<$Res,
        _$SrLegacyNutrientModelImpl>
    implements _$$SrLegacyNutrientModelImplCopyWith<$Res> {
  __$$SrLegacyNutrientModelImplCopyWithImpl(_$SrLegacyNutrientModelImpl _value,
      $Res Function(_$SrLegacyNutrientModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SrLegacyNutrientModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? unit = null,
  }) {
    return _then(_$SrLegacyNutrientModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SrLegacyNutrientModelImpl extends _SrLegacyNutrientModel {
  const _$SrLegacyNutrientModelImpl(
      {required this.id,
      required this.name,
      required this.amount,
      required this.unit})
      : super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final num amount;
  @override
  final String unit;

  @override
  String toString() {
    return 'SrLegacyNutrientModel(id: $id, name: $name, amount: $amount, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SrLegacyNutrientModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, amount, unit);

  /// Create a copy of SrLegacyNutrientModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SrLegacyNutrientModelImplCopyWith<_$SrLegacyNutrientModelImpl>
      get copyWith => __$$SrLegacyNutrientModelImplCopyWithImpl<
          _$SrLegacyNutrientModelImpl>(this, _$identity);
}

abstract class _SrLegacyNutrientModel extends SrLegacyNutrientModel {
  const factory _SrLegacyNutrientModel(
      {required final int id,
      required final String name,
      required final num amount,
      required final String unit}) = _$SrLegacyNutrientModelImpl;
  const _SrLegacyNutrientModel._() : super._();

  @override
  int get id;
  @override
  String get name;
  @override
  num get amount;
  @override
  String get unit;

  /// Create a copy of SrLegacyNutrientModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SrLegacyNutrientModelImplCopyWith<_$SrLegacyNutrientModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
