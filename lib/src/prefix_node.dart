import 'package:freezed_annotation/freezed_annotation.dart';

part 'prefix_node.freezed.dart';

part 'prefix_node.g.dart';

/// Class representing a [PrefixTree] node.
///
/// Properties:
///
/// [left], [right], [middle] -  are pointers to the next node.
/// [key] is the character the node represents.
/// [isEnd] will be true if it represents the end of a word.
@freezed
class PTNode with _$PTNode {
  const factory PTNode(
      {String? key,
      PTNode? left,
      PTNode? right,
      PTNode? middle,
      @Default(false) bool? isEnd}) = _PTNode;
  const PTNode._();

  factory PTNode.fromJson(Map<String, Object?> json) => _$PTNodeFromJson(json);
}




// class PTNode {
//   String? key;
//   bool? isEnd;
//   PTNode? left;
//   PTNode? middle;
//   PTNode? right;

//   PTNode({this.key, this.left, this.right, this.middle, this.isEnd = false});

//   /// Create PTNode from a JSON representation.
//   factory PTNode.fromJson(Map<String, dynamic> json) {
//     return PTNode(
//       key: json['key'],
//       isEnd: json['isEnd'],
//       left: json['left'] != null ? PTNode.fromJson(json['left']) : null,
//       middle: json['middle'] != null ? PTNode.fromJson(json['middle']) : null,
//       right: json['right'] != null ? PTNode.fromJson(json['right']) : null,
//     );
//   }

//   @override
//   String toString() {
//     return 'Node(key: $key, left: $left, right: $right, middle: $middle, isEnd: $isEnd)';
//   }
// }