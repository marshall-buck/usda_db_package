// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefix_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PTNodeImpl _$$PTNodeImplFromJson(Map<String, dynamic> json) => _$PTNodeImpl(
      key: json['key'] as String?,
      left: json['left'] == null
          ? null
          : PTNode.fromJson(json['left'] as Map<String, dynamic>),
      right: json['right'] == null
          ? null
          : PTNode.fromJson(json['right'] as Map<String, dynamic>),
      middle: json['middle'] == null
          ? null
          : PTNode.fromJson(json['middle'] as Map<String, dynamic>),
      isEnd: json['isEnd'] as bool? ?? false,
    );

Map<String, dynamic> _$$PTNodeImplToJson(_$PTNodeImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'left': instance.left,
      'right': instance.right,
      'middle': instance.middle,
      'isEnd': instance.isEnd,
    };
