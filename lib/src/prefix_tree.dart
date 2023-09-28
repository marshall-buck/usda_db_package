import 'dart:convert';

import 'package:database/src/prefix_node.dart';
import 'package:flutter/services.dart';

/// Class to load and search the Prefix Tree.

class PrefixTree {
  static PTNode? _root;

  PrefixTree(PTNode? node);

  static PTNode? get root => _root;

  /// Initializes the instance
  ///
  /// Parameters:
  /// - [path] The path of the rootBundle file.
  ///
  /// Returns the [_instance].
  static Future<void> init(String path) async {
    if (_root != null) {
      throw Exception('Instance is already initialized');
    }

    PTNode node = await _loadData(path);
    _root = node;
  }

  /// De-initializes the [PrefixTree] class.
  static void remove() {
    _root = null;
  }

  /// Opens and converts the rootBundle file.
  ///
  /// Parameters:
  /// - [path] The path of the rootBundle file.
  ///
  /// Returns the root [PTNode].
  static Future<PTNode> _loadData(String path) async {
    final String response = await rootBundle.loadString(path, cache: false);
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
  static List<String?> searchByPrefix(String prefix) {
    List<String> result = [];
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

  static void _collectWords(PTNode? node, String prefix, List<String> result) {
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

  static PTNode? _findNode(String prefix) {
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
