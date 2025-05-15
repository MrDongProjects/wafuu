class WordUtils {
  static (String main, String reading) parseWord(String word) {
    // 处理 "付[つ]きます" 格式
    final match = RegExp(r'([^\[]+)\[([^\]]+)\](.*)').firstMatch(word);
    if (match != null) {
      final mainForm = match.group(1)! + (match.group(3) ?? ''); // "付きます"
      final readingForm = match.group(2)! + (match.group(3) ?? ''); // "つきます"
      return (mainForm, readingForm);
    }
    return (word, '');
  }

  static List<(String type, String value)> parseConjugations(
      String conjugations) {
    final result = <(String, String)>[];

    // 解析表格格式
    final rows = RegExp(r'<tr><td[^>]*>(.*?)</td><td[^>]*>(.*?)</td></tr>')
        .allMatches(conjugations);

    for (var row in rows) {
      final type = row.group(1)?.trim() ?? '';
      final value = row.group(2)?.trim() ?? '';
      if (type.isNotEmpty && value.isNotEmpty) {
        result.add((type, value));
      }
    }

    return result;
  }
}
