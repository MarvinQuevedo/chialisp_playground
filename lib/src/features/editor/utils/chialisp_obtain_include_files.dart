List<String> chialispObtainINcludeFiles(String chiaLispCode) {
  RegExp includePattern = RegExp(r'\(include (.*?)\)');
  Iterable<RegExpMatch> includeMatches =
      includePattern.allMatches(chiaLispCode);
  List<String> includedFiles = [];
  for (RegExpMatch match in includeMatches) {
    includedFiles.add(match.group(1)!);
  }

  return includedFiles;
}
