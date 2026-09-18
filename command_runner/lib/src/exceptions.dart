class ArgumentException extends FormatException {
  //El comando parseado antes de descubrir el error
  //Esto estaria vacio si el error fue en el parseo raiz
  final String? command;

  //El nombre del argumento que estaba siendo parseado/analizado cuando el error
  //fue descubierto
  final String? argumentName;

  ArgumentException(
    super.message, [
    this.command,
    this.argumentName,
    super.source,
    super.offset,
  ]);

  @override
  String toString() {
    return 'ArgumentException: $message';
  }
}
