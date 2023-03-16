List<String?> parseLisp(String chialispCode) {
  RegExp parameterPattern = RegExp(r'\((.*?)\)');
  String? parametersString =
      parameterPattern.firstMatch(chialispCode)?.group(1);
  List<String> parameters = parametersString?.split(" ") ?? [];
  parameters = parameters
      .where((element) => element != 'mod' && element.trim().isNotEmpty)
      .map((e) => e.replaceAll("(", "").trim())
      .where((element) => element.isNotEmpty)
      .toList();
  return parameters;
}
