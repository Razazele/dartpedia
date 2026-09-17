import 'dart:async';
import 'dart:collection';

import 'command_runner_base.dart';

enum OptionType { flag, option }

//Se vuelve un subtipo de CliElement, una clase abstracta pensada para ser usada como una extension en varias clases
class Option extends CliElement {
  Option(
    this.name, {
    required this.type,
    this.help,
    this.abbr,
    this.defaultValue,
    this.valueHelp,
  });

  //Override esta pensado para cumplir con los campos provenientes de la clase abstracta CliElement
  @override
  final String name;

  final OptionType type;
  @override
  final String? help;

  final String? abbr;

  @override
  final Object? defaultValue;
  @override
  final String? valueHelp;

  @override
  String get usage {
    if (abbr != null) {
      return '-$abbr,--$name: $help';
    }

    return '--$name: $help';
  }
}

class ArgResults {
  String? command;
  String? commandArg;
  //options map (Map<Option, Object?>): Associates each Option instance with its parsed user input.
  Map<Option, Object?> options = {};

  //Devuelve true si el flag existe y es true
  bool flag(String name) {
    //where() method in flag(): Filters map keys to inspect only boolean flags
    for (var option in options.keys.where(
      (option) => option.type == OptionType.flag,
    )) {
      if (option.name == name) {
        //Type cast (as bool): Tells the type checker to treat the value as a bool because flags always store boolean values.
        return options[option] as bool;
      }
    }
    return false;
  }

  bool hasOption(String name) {
    return options.keys.any((option) => option.name == name);
  }

  //  Record return type
  // Returns a lightweight, named record grouping both the Option and its value without declaring a separate class.
  ({Option option, Object? input}) getOption(String name) {
    var mapEntry = options.entries.firstWhere(
      (entry) => entry.key.name == name || entry.key.abbr == name,
    );

    return (option: mapEntry.key, input: mapEntry.value);
  }
}

abstract class CliElement {
  String get name;
  String? get help;

  //En el caso de flags, el valor por defecto es bool,
  //En otras opciones y comandos, el valor por defecto es string
  // NB: flags solo son Options objects que no toman argumentos
  Object? get defaultValue;
  String? get valueHelp;

  String get usage;
}

abstract class Command extends CliElement {
  @override
  String get name;

  String get description;
  bool get requiresArgument => false;

  //Late promete a dart que esta variable ya esta asignada antes de de leerse
  late CommandRunner runner;

  @override
  String? help;

  @override
  String? defaultValue;

  @override
  String? valueHelp;
}
