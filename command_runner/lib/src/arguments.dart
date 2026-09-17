enum OptionType {flag,option}

class Option {
    Option(
    this.name, 
    {
        required this.type
        this.help,
        this.abbr,
        this.defaultValue,
        this.valueHelp,    
    
    });
    
    final String name;
    final OptionType type;
    final String? help;
    final String? abbr;
    final Object? defaultValue;
    final String? valueHelp;

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
    Map<Option,Object?> options = {};

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
    ({Option option,Object? input}) getOption(String name) {
        var mapEntry = options.entries.firstWhere(
            (entry) => entry.key.name == name || entry.key.abbr == name,
        );

        return (option:mapEntry.key, input: mapEntry.value);
    }

}