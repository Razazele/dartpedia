import 'package:cli/cli.dart' as cli;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:command_runner/command_runner.dart';
//Constantes se ejecutan enseguida al momento de compilar
const version = '0.0.1';

//Signo ? representa que puede ser null el string, como en TS
void main(List<String> arguments) async {

  var runner = CommandRunner() ;
  await runner.run(arguments);

  /*if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  }
  else if (arguments.first == 'version') {
    //El simbolo $ toma las variables dentro del codigo (Interpolacion de strings)
    print('Dartpedia CLI version $version');
  }
  else if (arguments.first == 'wikipedia') {
      //Sublist toma todo desde el indice 1 en adelante, no solo un elemento
      final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
      searchWikipedia(inputArgs); // no se necesita await para el main
  }
  else {
    printUsage();
  }*/
  
}

void printUsage () {
  print(
  "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'");
}

void searchWikipedia(List<String>? arguments) async {
  //Variables final solo se les asigna valor una vez
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    //Toma input, si el input es nulo se pone un string vacio
    final inputFromStdin = stdin.readLineSync() ?? '';
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('No article title provided. Exiting.');
      return;
    }
    articleTitle = inputFromStdin;
  }
  else {
    //Si existe busqueda, se juntan los argumentos en un string 
    articleTitle = arguments.join(' ');
  }
  print('Buscando articulos sobre "$articleTitle". Por favor espere.');


  //Llamada a la API 
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent);
}



//The Future<String> return type indicates that this function will eventually produce a String result, but not immediately, because it's an asynchronous operation.
Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org', //Wikipedia API Domain
    '/api/rest_v1/page/summary/$articleTitle', //API path for article summary
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  }

  return 'Error: Error al obtener article "$articleTitle". Status code: ${response.statusCode}';

}