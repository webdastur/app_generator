import 'package:args/args.dart';
import 'package:logger/logger.dart';

import 'core/generator_options.dart';

Logger logger = Logger(
  filter: null,
  printer: PrettyPrinter(),
);

void main(List<String> args) {}

void handleArgs(List<String> args) {
  var generatorOptions = GeneratorOptions();
  var argParser = _argParser(generatorOptions);
  argParser.parse(args);
}

ArgParser _argParser(GeneratorOptions generatorOptions) {
  var argParser = ArgParser();

  argParser.addOption('help', abbr: 'h', help: 'Help');

  argParser.addOption(
    'name',
    help: 'GetX Controller Name',
    abbr: 'n',
    callback: (value) {
      if (value == null) {
        logger.d("Please provide Controller name");
      } else {
        generatorOptions.outputFileName = value;
      }
    },
  );

  argParser.addOption(
    'output',
    help: 'GetX Output File Directory',
    abbr: 'o',
    callback: (value) {
      generatorOptions.outputDir = value;
    },
  );

  return argParser;
}
