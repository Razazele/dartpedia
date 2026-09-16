import 'package:cli/cli.dart' as cli;
import 'dart:io';

//Constantes se ejecutan enseguida al momento de compilar
const version = '0.0.1';

//Signo ? representa que puede ser null el string, como en TS
void main(List<String>? arguments) {

  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  }
  else if (arguments.first == 'version') {
    //El simbolo $ toma las variables dentro del codigo (Interpolacion de strings)
    print('Dartpedia CLI version $version');
  }
  else if (arguments.first == 'search') {
      //Sublist toma todo desde el indice 1 en adelante, no solo un elemento
      final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
      searchWikipedia(inputArgs);
  }
  else {
    printUsage();
  }
  
}

void printUsage () {
  print(
  "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'");
}

void searchWikipedia(List<String>? arguments) {
  //Variables final solo se les asigna valor una vez
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title.');
    //Toma input, si el input es nulo se pone un string vacio
    articleTitle = stdin.readLineSync() ?? '';
  }
  else {
    //Si existe busqueda, se juntan los argumentos en un string 
    articleTitle = arguments.join(' ');
  }
  print('Buscando articulos sobre "$articleTitle". Por favor espere.');
  print('Aqui Tienes!');
  print('(Pretender que este es un articulo sobre "$articleTitle")');
}