import 'package:command_runner/command_runner.dart';

const version = '0.0.1';
void main(List<String> arguments) {
  //Agregar metodo onError
  /* The cascade notation ..addCommand(...) calls addCommand 
  on the newly constructed 
  CommandRunner and returns that runner instance, enabling 
  concise method chaining before passing arguments to run().*/
  var commandRunner = CommandRunner(
    onError: (Object error) {
      if (error is Error) {
        throw error;
      }
      if (error is Exception) {
        print(error);
      }
    },
  )..addCommand(HelpCommand());
  commandRunner.run(arguments);
}
