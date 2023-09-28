// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prefix_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PTNode _$PTNodeFromJson(Map<String, dynamic> json) {
  return _PTNode.fromJson(json);
}

/// @nodoc
mixin _$PTNode {
  String? get key => throw _privateConstructorUsedError;
  PTNode? get left => throw _privateConstructorUsedError;
  PTNode? get right => throw _privateConstructorUsedError;
  PTNode? get middle => throw _privateConstructorUsedError;
  bool? get isEnd => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PTNodeCopyWith<PTNode> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PTNodeCopyWith<$Res> {
  factory $PTNodeCopyWith(PTNode value, $Res Function(PTNode) then) =
      _$PTNodeCopyWithImpl<$Res, PTNode>;
  @useResult
  $Res call(
      {String? key, PTNode? left, PTNode? right, PTNode? middle, bool? isEnd});

  $PTNodeCopyWith<$Res>? get left;
  $PTNodeCopyWith<$Res>? get right;
  $PTNodeCopyWith<$Res>? get middle;
}

/// @nodoc
class _$PTNodeCopyWithImpl<$Res, $Val extends PTNode>
    implements $PTNodeCopyWith<$Res> {
  _$PTNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? left = freezed,
    Object? right = freezed,
    Object? middle = freezed,
    Object? isEnd = freezed,
  }) {
    return _then(_value.copyWith(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      left: freezed == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as PTNode?,
      right: freezed == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as PTNode?,
      middle: freezed == middle
          ? _value.middle
          : middle // ignore: cast_nullable_to_non_nullable
              as PTNode?,
      isEnd: freezed == isEnd
          ? _value.isEnd
          : isEnd // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PTNodeCopyWith<$Res>? get left {
    if (_value.left == null) {
      return null;
    }

    return $PTNodeCopyWith<$Res>(_value.left!, (value) {
      return _then(_value.copyWith(left: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PTNodeCopyWith<$Res>? get right {
    if (_value.right == null) {
      return null;
    }

    return $PTNodeCopyWith<$Res>(_value.right!, (value) {
      return _then(_value.copyWith(right: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PTNodeCopyWith<$Res>? get middle {
    if (_value.middle == null) {
      return null;
    }

    return $PTNodeCopyWith<$Res>(_value.middle!, (value) {
      return _then(_value.copyWith(middle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PTNodeImplCopyWith<$Res> implements $PTNodeCopyWith<$Res> {
  factory _$$PTNodeImplCopyWith(
          _$PTNodeImpl value, $Res Function(_$PTNodeImpl) then) =
      __$$PTNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? key, PTNode? left, PTNode? right, PTNode? middle, bool? isEnd});

  @override
  $PTNodeCopyWith<$Res>? get left;
  @override
  $PTNodeCopyWith<$Res>? get right;
  @override
  $PTNodeCopyWith<$Res>? get middle;
}

/// @nodoc
class __$$PTNodeImplCopyWithImpl<$Res>
    extends _$PTNodeCopyWithImpl<$Res, _$PTNodeImpl>
    implements _$$PTNodeImplCopyWith<$Res> {
  __$$PTNodeImplCopyWithImpl(
      _$PTNodeImpl _value, $Res Function(_$PTNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? left = freezed,
    Object? right = freezed,
    Object? middle = freezed,
    Object? isEnd = freezed,
  }) {
    return _then(_$PTNodeImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      left: freezed == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as PTNode?,
      right: freezed == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as PTNode?,
      middle: freezed == middle
          ? _value.middle
          : middle // ignore: cast_nullable_to_non_nullable
              as PTNode?,
      isEnd: freezed == isEnd
          ? _value.isEnd
          : isEnd // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PTNodeImpl extends _PTNode {
  const _$PTNodeImpl(
      {this.key, this.left, this.right, this.middle, this.isEnd = false})
      : super._();

  factory _$PTNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PTNodeImplFromJson(json);

  @override
  final String? key;
  @override
  final PTNode? left;
  @override
  final PTNode? right;
  @override
  final PTNode? middle;
  @override
  @JsonKey()
  final bool? isEnd;

  @override
  String toString() {
    return 'PTNode(key: $key, left: $left, right: $right, middle: $middle, isEnd: $isEnd)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PTNodeImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.right, right) || other.right == right) &&
            (identical(other.middle, middle) || other.middle == middle) &&
            (identical(other.isEnd, isEnd) || other.isEnd == isEnd));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, key, left, right, middle, isEnd);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PTNodeImplCopyWith<_$PTNodeImpl> get copyWith =>
      __$$PTNodeImplCopyWithImpl<_$PTNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PTNodeImplToJson(
      this,
    );
  }
}

abstract class _PTNode extends PTNode {
  const factory _PTNode(
      {final String? key,
      final PTNode? left,
      final PTNode? right,
      final PTNode? middle,
      final bool? isEnd}) = _$PTNodeImpl;
  const _PTNode._() : super._();

  factory _PTNode.fromJson(Map<String, dynamic> json) = _$PTNodeImpl.fromJson;

  @override
  String? get key;
  @override
  PTNode? get left;
  @override
  PTNode? get right;
  @override
  PTNode? get middle;
  @override
  bool? get isEnd;
  @override
  @JsonKey(ignore: true)
  _$$PTNodeImplCopyWith<_$PTNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
