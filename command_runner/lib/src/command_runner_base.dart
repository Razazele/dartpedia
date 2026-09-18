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
    ArgResults results = ArgResults();
    if (input.isEmpty) return results;

    //Arroja exception si el comando no es reconocido

    if (_commands.containsKey(input.first)) {
      results.command = _commands[input.first];
      input = input.sublist(1);
    } else {
      throw ArgumentException(
        'La primera palabra del input debe ser un comando.',
        null,
        input.first,
      );
    }

    //Arroja una excepcion si multiples comandos son ingresados
    if (results.command != null &&
        input.isNotEmpty &&
        _commands.containsKey(input.first)) {
      throw ArgumentException(
        'El input solo puede contener un comando. Obtenido ${input.first} y ${results.command!.name}.',
        null,
        input.first,
      );
    }

    //Seccion : Manejar opciones, incluyendo flags
    Map<Option, Object?> inputOptions = {};

    int i = 0;
    //Manejo de excepciones
    while (i < input.length) {
      if (input[i].startsWith('-')) {
        var base = _removeDash(input[i]);
        //Arroja una excepcion si el la opcion no es reconocida para el comando dado
        var option = results.command!.options.firstWhere(
          (option) => option.name == base || option.abbr == base,
          orElse: () {
            throw ArgumentException(
              'Unknown option ${input[i]}',
              results.command!.name,
              input[i],
            );
          },
        );
        if (option.type == OptionType.option) {
          //Arroja Excepcion si la opcion requiere un arg pero no se dio ninguno.
          if (i + 1 >= input.length) {
            throw ArgumentException(
              'Opcion ${option.name} requiere un argumento',
              results.command!.name,
              option.name,
            );
          }
        }
        //Arroja excepcion si se obtuvo otra opcion
        if (input[i + 1].startsWith('-')) {
          throw ArgumentException(
            'Opcion ${option.name} requiere un argumento. pero obtuvo otra opcion ${input[i + 1]}',
            results.command!.name,
            option.name,
          );
        }

        var arg = input[i + 1];
        inputOptions[option] = arg;
        i++;
      } else {
        //Arroja Excepcion si se provee mas de un argumento
        if (results.commandArg != null && results.commandArg!.isNotEmpty) {
          throw ArgumentException(
            'Comandos solo pueden tener hasta 1 argumento',
            results.command!.name,
            input[i],
          );
        }

        results.commandArg = input[i];
      }
      i++;
    }
    results.options = inputOptions;
    return results;
  }

  String _removeDash(String input) {
    if (input.startsWith('--')) {
      return input.substring(2);
    }
    if (input.startsWith('-')) {
      return input.substring(1);
    }

    return input;
  }

  String get usage {
    final exeFile = Platform.script.path.split('/').last;
    return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
  }
}
