// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SrLegacyFoodModel {
  int get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<SrLegacyNutrientModel> get nutrients =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SrLegacyFoodModelCopyWith<SrLegacyFoodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SrLegacyFoodModelCopyWith<$Res> {
  factory $SrLegacyFoodModelCopyWith(
          SrLegacyFoodModel value, $Res Function(SrLegacyFoodModel) then) =
      _$SrLegacyFoodModelCopyWithImpl<$Res, SrLegacyFoodModel>;
  @useResult
  $Res call(
      {int id, String description, List<SrLegacyNutrientModel> nutrients});
}

/// @nodoc
class _$SrLegacyFoodModelCopyWithImpl<$Res, $Val extends SrLegacyFoodModel>
    implements $SrLegacyFoodModelCopyWith<$Res> {
  _$SrLegacyFoodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? nutrients = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      nutrients: null == nutrients
          ? _value.nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as List<SrLegacyNutrientModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SrLegacyFoodModelImplCopyWith<$Res>
    implements $SrLegacyFoodModelCopyWith<$Res> {
  factory _$$SrLegacyFoodModelImplCopyWith(_$SrLegacyFoodModelImpl value,
          $Res Function(_$SrLegacyFoodModelImpl) then) =
      __$$SrLegacyFoodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, String description, List<SrLegacyNutrientModel> nutrients});
}

/// @nodoc
class __$$SrLegacyFoodModelImplCopyWithImpl<$Res>
    extends _$SrLegacyFoodModelCopyWithImpl<$Res, _$SrLegacyFoodModelImpl>
    implements _$$SrLegacyFoodModelImplCopyWith<$Res> {
  __$$SrLegacyFoodModelImplCopyWithImpl(_$SrLegacyFoodModelImpl _value,
      $Res Function(_$SrLegacyFoodModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? nutrients = null,
  }) {
    return _then(_$SrLegacyFoodModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      nutrients: null == nutrients
          ? _value._nutrients
          : nutrients // ignore: cast_nullable_to_non_nullable
              as List<SrLegacyNutrientModel>,
    ));
  }
}

/// @nodoc

class _$SrLegacyFoodModelImpl extends _SrLegacyFoodModel {
  const _$SrLegacyFoodModelImpl(
      {required this.id,
      required this.description,
      required final List<SrLegacyNutrientModel> nutrients})
      : _nutrients = nutrients,
        super._();

  @override
  final int id;
  @override
  final String description;
  final List<SrLegacyNutrientModel> _nutrients;
  @override
  List<SrLegacyNutrientModel> get nutrients {
    if (_nutrients is EqualUnmodifiableListView) return _nutrients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nutrients);
  }

  @override
  String toString() {
    return 'SrLegacyFoodModel(id: $id, description: $description, nutrients: $nutrients)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SrLegacyFoodModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._nutrients, _nutrients));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, description,
      const DeepCollectionEquality().hash(_nutrients));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SrLegacyFoodModelImplCopyWith<_$SrLegacyFoodModelImpl> get copyWith =>
      __$$SrLegacyFoodModelImplCopyWithImpl<_$SrLegacyFoodModelImpl>(
          this, _$identity);
}

abstract class _SrLegacyFoodModel extends SrLegacyFoodModel {
  const factory _SrLegacyFoodModel(
          {required final int id,
          required final String description,
          required final List<SrLegacyNutrientModel> nutrients}) =
      _$SrLegacyFoodModelImpl;
  const _SrLegacyFoodModel._() : super._();

  @override
  int get id;
  @override
  String get description;
  @override
  List<SrLegacyNutrientModel> get nutrients;
  @override
  @JsonKey(ignore: true)
  _$$SrLegacyFoodModelImplCopyWith<_$SrLegacyFoodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
