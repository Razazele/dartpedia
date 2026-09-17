import 'package:command_runner/command_runner.dart';

const version = '0.0.1';
void main(List<String> arguments) {
  /* The cascade notation ..addCommand(...) calls addCommand 
  on the newly constructed 
  CommandRunner and returns that runner instance, enabling 
  concise method chaining before passing arguments to run().*/
  var commandRunner = CommandRunner()..addCommand(HelpCommand());
  commandRunner.run(arguments);
}
