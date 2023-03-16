String chialispRemoveComments(String chialispCode) {
  RegExp commentRegex = RegExp(r';.*');

  String lispCodeSinComentarios = chialispCode.replaceAll(commentRegex, '');
  // remove all line breaks
  lispCodeSinComentarios = lispCodeSinComentarios.replaceAll(RegExp(r'\n'), '');
  lispCodeSinComentarios = lispCodeSinComentarios.replaceAll(RegExp(r'\r'), '');
  // remove all double spaces
  lispCodeSinComentarios = lispCodeSinComentarios.replaceAll("  ", ' ');
  //remove all tabs
  lispCodeSinComentarios = lispCodeSinComentarios.replaceAll(RegExp(r'\t'), ''); 
  lispCodeSinComentarios = lispCodeSinComentarios.replaceAll(RegExp(r'\s+'), ' ');

  return lispCodeSinComentarios;
}

 