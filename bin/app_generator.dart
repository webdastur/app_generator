import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'core/generator_options.dart';
import 'templates/getx_template.dart';

AnsiPen info = AnsiPen()..green();
AnsiPen error = AnsiPen()..red();

void main(List<String> args) {
  ansiColorDisabled = false;
  if (args.length == 1 && (args[0] == '--help' || args[0] == '--h')) {
    printHelp();
  } else {
    handleArgs(args);
  }
}

void handleArgs(List<String> args) {
  var generatorOptions = GeneratorOptions();
  var argParser = _argParser(generatorOptions);
  argParser.parse(args);
  handle(generatorOptions);
}

Future handle(GeneratorOptions generatorOptions) async {
  if (generatorOptions.outputDir == null) {
    return;
  }
  if (generatorOptions.outputFileName == null) {
    return;
  }

  Directory currentDir = Directory.current;
  Directory output = Directory.fromUri(Uri.parse(generatorOptions.outputDir!));
  Directory outputDir = Directory(path.join(currentDir.path, output.path));

  if (!await outputDir.exists()) {
    print(error("Output directory not found!"));
    return;
  }

  String getXControllerFileName = generatorOptions.outputFileName!.split(new RegExp(r"(?<=[a-z])(?=[A-Z])")).join("_").toLowerCase();
  File file = File(path.join(outputDir.path, "$getXControllerFileName.dart"));
  if (!await file.exists()) {
    print(info("File ${file.path} not found."));
    print(info("Try to create new one."));
    await file.create();
    write(generatorOptions, file);
  } else {
    write(generatorOptions, file);
  }
}

Future write(GeneratorOptions generatorOptions, File file)async {
  print(info("Generating."));
  await file.writeAsString(GetXTemplate.renderString({'name': generatorOptions.outputFileName!}));
  print(info("File generated to ${file.path}."));
}

void printHelp() {
  var argParser = _argParser(null);
  print(info(argParser.usage));
}

ArgParser _argParser(GeneratorOptions? generatorOptions) {
  var argParser = ArgParser();

  argParser.addOption('help', abbr: 'h', help: 'Help');

  argParser.addOption(
    'name',
    help: 'GetX Controller Name',
    abbr: 'n',
    callback: (value) {
      if (value == null) {
        print(error("Please provide GetX Controller name."));
      } else {
        generatorOptions!.outputFileName = value;
      }
    },
  );

  argParser.addOption(
    'output',
    help: 'GetX Output File Directory',
    abbr: 'o',
    callback: (value) {
      if (value == null) {
        print(error("Please provide output directory."));
      } else {
        generatorOptions!.outputDir = value;
      }
    },
    defaultsTo: "lib/data/controllers",
  );

  return argParser;
}
