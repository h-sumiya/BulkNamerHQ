import 'package:characters/characters.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

String getSlicedString(String src, int start, int? end) {
  final characters = src.characters.toList();
  final s = (start - 1).clamp(0, characters.length);
  final e =
      end != null ? (end + 1).clamp(0, characters.length) : characters.length;
  return characters.sublist(s, e).join();
}

class Rule {
  final List<RuleSegment> segments;

  Rule(this.segments);

  static Rule parse(String rule) {
    final segments = <RuleSegment>[];
    final length = rule.length;
    int i = 0;

    while (i < length) {
      if (rule[i] == '\\') {
        if (i + 1 < length) {
          final nextChar = rule[i + 1];
          if (nextChar == '{' || nextChar == '}' || nextChar == '\\') {
            segments.add(LiteralSegment(nextChar));
            i += 2;
            continue;
          }
        }
        segments.add(LiteralSegment('\\'));
        i += 1;
        continue;
      }

      if (rule[i] == '{') {
        final endIndex = _findClosingBrace(rule, i + 1);
        if (endIndex == -1) {
          throw FormatException('未閉じの { が見つかりました: $rule');
        }

        final placeholderContent = rule.substring(i + 1, endIndex);
        segments.add(_parsePlaceholder(placeholderContent));
        i = endIndex + 1;
        continue;
      }

      final start = i;
      while (i < length && rule[i] != '{' && rule[i] != '\\') {
        i++;
      }
      segments.add(LiteralSegment(rule.substring(start, i)));
    }

    return Rule(segments);
  }

  static int _findClosingBrace(String rule, int start) {
    int braceCount = 1;
    for (int i = start; i < rule.length; i++) {
      if (rule[i] == '\\') {
        i++;
        continue;
      }
      if (rule[i] == '{') {
        braceCount++;
      } else if (rule[i] == '}') {
        braceCount--;
        if (braceCount == 0) {
          return i;
        }
      }
    }
    return -1;
  }

  static RuleSegment _parsePlaceholder(String placeholder) {
    final regex = RegExp(
        r'^(num(?::(\d+))?(?:\[(\d+)(?::(\d+))?\])?|nfkc_src(?:\[(\d+):?(\d+)?\])?|src(?:\[(\d+):?(\d+)?\])?)$');
    final match = regex.firstMatch(placeholder);
    if (match == null) {
      throw FormatException('無効なプレースホルダー形式: {$placeholder}');
    }

    if (placeholder.startsWith('num')) {
      final padding =
          match.group(2) != null ? int.parse(match.group(2)!) : null;
      final start = match.group(3) != null ? int.parse(match.group(3)!) : 0;
      final step = match.group(4) != null ? int.parse(match.group(4)!) : 1;
      return NumSegment(padding: padding, start: start, step: step);
    } else if (placeholder.startsWith('nfkc_src')) {
      final start = match.group(5) != null ? int.parse(match.group(5)!) : 0;
      final end = match.group(6) != null ? int.parse(match.group(6)!) : null;
      return NFKCSourceSegment(start: start, end: end);
    } else if (placeholder.startsWith('src')) {
      final start = match.group(7) != null ? int.parse(match.group(7)!) : 0;
      final end = match.group(8) != null ? int.parse(match.group(8)!) : null;
      return SourceSegment(start: start, end: end);
    } else {
      throw FormatException('未知のプレースホルダー: {$placeholder}');
    }
  }

  String apply(int index, String src) {
    return segments.map((segment) => segment.evaluate(index, src)).join();
  }
}

abstract class RuleSegment {
  String evaluate(int index, String src);
}

class LiteralSegment extends RuleSegment {
  final String text;

  LiteralSegment(this.text);

  @override
  String evaluate(int index, String src) => text;
}

class NumSegment extends RuleSegment {
  final int? padding;
  final int start;
  final int step;

  NumSegment({this.padding, this.start = 0, this.step = 1});

  @override
  String evaluate(int index, String src) {
    final num = start + index * step;
    if (padding != null) {
      return num.toString().padLeft(padding!, '0');
    }
    return num.toString();
  }
}

class SourceSegment extends RuleSegment {
  final int start;
  final int? end;

  SourceSegment({this.start = 0, this.end});

  @override
  String evaluate(int index, String src) {
    return getSlicedString(src, start, end);
  }
}

class NFKCSourceSegment extends RuleSegment {
  final int start;
  final int? end;

  NFKCSourceSegment({this.start = 0, this.end});

  @override
  String evaluate(int index, String src) {
    final normalized = unorm.nfkc(src);
    return getSlicedString(normalized, start, end);
  }
}
