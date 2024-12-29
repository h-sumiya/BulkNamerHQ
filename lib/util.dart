import 'dart:io';

void fileSmartSort(List<File> files) {
  files.sort((a, b) {
    String fileNameA = a.path.split(Platform.pathSeparator).last;
    String fileNameB = b.path.split(Platform.pathSeparator).last;
    fileNameA = _convertFullWidthToHalfWidth(fileNameA);
    fileNameB = _convertFullWidthToHalfWidth(fileNameB);

    return _naturalCompare(fileNameA, fileNameB);
  });
}

String _convertFullWidthToHalfWidth(String str) {
  const fullWidth = "０１２３４５６７８９";
  const halfWidth = "0123456789";
  
  for (var i = 0; i < fullWidth.length; i++) {
    str = str.replaceAll(fullWidth[i], halfWidth[i]);
  }
  return str;
}

int _naturalCompare(String a, String b) {
  final pattern = RegExp(r'(\d+|\D+)');
  final partsA = pattern.allMatches(a).map((m) => m.group(0)!).toList();
  final partsB = pattern.allMatches(b).map((m) => m.group(0)!).toList();

  for (var i = 0; i < partsA.length && i < partsB.length; i++) {
    final partA = partsA[i];
    final partB = partsB[i];
    if (RegExp(r'^\d+$').hasMatch(partA) && RegExp(r'^\d+$').hasMatch(partB)) {
      final numA = int.parse(partA);
      final numB = int.parse(partB);
      if (numA != numB) return numA.compareTo(numB);
    } else {
      final comp = partA.compareTo(partB);
      if (comp != 0) return comp;
    }
  }

  return partsA.length.compareTo(partsB.length);
}
