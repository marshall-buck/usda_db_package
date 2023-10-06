import 'dart:convert';
import 'dart:developer' as dev;

import 'package:usda_db/src/file_loader_service.dart';
import 'package:usda_db/src/prefix_node.dart';

/// Class to load and search the Prefix Tree.

class PrefixTree {
  FileLoaderService fileLoader;

  PTNode? _root;

  static final PrefixTree _singleton = PrefixTree._internal();

  PrefixTree._internal() : fileLoader = FileLoaderService();
  factory PrefixTree(FileLoaderService fileLoader) {
    _singleton.fileLoader = fileLoader;
    return _singleton;
  }

  PTNode? get root => _root;

  /// Initializes the instance
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  ///
  Future<void> init(String path) async {
    _root = await _loadData(path);
    dev.log('init()',
        name: 'PrefixTree -  ${_root != null ? "success" : "_root is null"}');
  }

  /// Dispose Tree
  void dispose() => _root = null;

  /// Opens and converts the  file.
  ///
  /// Parameters:
  /// - [path] The path of the  file.
  ///
  /// Returns the root [PTNode].
  Future<PTNode> _loadData(String path) async {
    final String response = await fileLoader.loadData(path);
    Map<String, dynamic> jsonMap = await json.decode(response);

    return PTNode.fromJson(jsonMap['root']);
  }

  /// Searches for all words starting with a given prefix.
  ///
  /// Parameters:
  /// - [prefix] The prefix to search for.
  ///
  /// Returns a list of strings that start with the prefix.
  /// If no matches are found, an empty list is returned.
  List<String?> searchByPrefix(String prefix) {
    List<String?> result = [];
    if (prefix.isEmpty) return result;
    PTNode? node = _findNode(prefix);

    if (node != null) {
      if (node.isEnd == true) {
        // If the prefix itself is a word, add it to the result
        result.add(prefix);
      }

      // Collect all words starting from the node's subtree
      _collectWords(node.middle, prefix, result);
    }

    return result;
  }

  /// Recursively collects all words from a given node and its subtree.
  ///
  /// Parameters:
  /// - [node]  The current node to collect words from.
  /// - [prefix]  The prefix to match.
  /// - [result]  The list to collect the matched words.

  void _collectWords(PTNode? node, String prefix, List<String?> result) {
    if (node == null) {
      return;
    }

    // Recursively collect words from the left, middle, and right nodes
    _collectWords(node.left, prefix, result);

    // If the current node is an end node, add it to the result list
    if (node.isEnd == true) {
      result.add(prefix + node.key!);
    }

    _collectWords(node.middle, prefix + node.key!, result);
    _collectWords(node.right, prefix, result);
  }

  /// Finds the node that corresponds to the given prefix.
  ///
  /// Parameters:
  /// - [prefix]  The prefix to search for.
  ///
  /// Returns the node that corresponds to the prefix, or null if not found.

  PTNode? _findNode(String prefix) {
    PTNode? node = _root;
    int pos = 0;

    while (node != null) {
      if (prefix.codeUnitAt(pos) < node.key!.codeUnitAt(0)) {
        node = node.left;
      } else if (prefix.codeUnitAt(pos) > node.key!.codeUnitAt(0)) {
        node = node.right;
      } else {
        pos++;

        if (pos == prefix.length) {
          // Reached the end of the prefix
          return node;
        }

        node = node.middle;
      }
    }

    return null;
  }

  @override
  String toString() {
    return '$_root';
  }
}
