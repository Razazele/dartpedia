import 'dart:collection';
import 'dart:io';
import 'dart:async';

import 'exceptions.dart';

import 'arguments.dart';

class CommandRunner {
  //Constructor que acepta el callback opcional, en caso de que
  //Los usuarios del paquete quieran customizarlo
  CommandRunner({this.onError});

  final Map<String, Command> _commands = <String, Command>{};

  UnmodifiableSetView<Command> get commands =>
      ///El spread operator mapea los valores del _commands privado en un nuevo set, previniendo que las llamadas
      ///modifiquen el map interno
      UnmodifiableSetView<Command>(<Command>{..._commands.values});

  //Propiedad onError
  FutureOr<void> Function(Object)? onError;

  Future<void> run(List<String> input) async {
    //Step 6 agregado try/catch
    try {
      final ArgResults results = parse(input);
      if (results.command != null) {
        //El ! de results.command! indica que el command definitvamente no es nulo debido a la verificacion anterior
        Object? output = await results.command!.run(results);
        print(output.toString());
      }
      //el on exception asegura que solo tome verdaderas excepciones
      //Los bugs de codigo los propagara para que puedas arreglarlos
    } on Exception catch (exception) {
      if (onError != null) {
        //Devuelve el error con el callback customizado
        onError!(exception);
      } else {
        //Mantiene el error y stack trace original
        rethrow;
      }
    }
  }

  void addCommand(Command command) {
    _commands[command.name] = command;
    //Asigna la instancia runner al comando cuando se registra, completando la promesa hecha por la variable late en Command
    command.runner = this;
  }

  ArgResults parse(List<String> input) {
    var results = ArgResults();
    results.command = _commands[input.first];
    return results;
  }

  String get usage {
    final exeFile = Platform.script.path.split('/').last;
    return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
  }
}
