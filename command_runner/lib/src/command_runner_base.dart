// TODO: Put public facing types in this file.

/// Checks if you are awesome. Spoiler: you are.
class CommandRunner {
  //Corre la logica de command-line con los argumentos dados
  Future<void> run(List<String> input) async {
    print('CommandRunner received arguments: $input');
  }
}
