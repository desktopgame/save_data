import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:save_data_annotation/save_data_annotation.dart';
import 'package:source_gen/source_gen.dart';

class MyGenerator extends GeneratorForAnnotation<Content> {
  final TypeChecker hasValue = TypeChecker.fromRuntime(Content);

  String classNameToFileName(String className) {
    var sb = StringBuffer();
    var regA = RegExp(r'[A-Z]');
    bool underscore = false;
    for (int i = 0; i < className.length; i++) {
      var ch = className.substring(i, i + 1);
      if (regA.hasMatch(ch)) {
        if (underscore) {
          sb.write("_");
          underscore = false;
        }
        sb.write(ch.toLowerCase());
      } else {
        sb.write(ch);
        underscore = true;
      }
    }
    return sb.toString();
  }

  String _generateProviderClass(ClassElement klass) {
    var buffer = StringBuffer();
    buffer.writeln("import 'dart:convert';");
    buffer.writeln("import './${classNameToFileName(klass.name)}.dart';");
    buffer.writeln("import 'package:optional/optional.dart';");
    buffer.writeln("import 'package:save_data_lib/save_data_lib.dart';");
    buffer.writeln("");
    buffer.writeln('class ${klass.name}Provider implements Provider {');
    buffer.writeln("  Optional<Object> _cache = Optional.empty();");
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln("  Optional<Object> get cache => _cache;");
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln("  void fromJson(String str) {");
    buffer.writeln(
        '    this._cache = Optional.of(${klass.name}.fromJson(json.decode(str)));');
    buffer.writeln('  }');
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln("  void clear() {");
    buffer.writeln("    this._cache = Optional.of(${klass.name}());");
    buffer.writeln("  }");
    buffer.writeln("");
    buffer.writeln("  @override");
    buffer.writeln("  String toJson() {");
    buffer.writeln("    return _cache.isPresent");
    buffer.writeln(
        "      ? json.encode((_cache.value as ${klass.name}).toJson())");
    buffer.writeln("      : \"{}\";");
    buffer.writeln("  }");
    buffer.writeln("");
    buffer.writeln("  static void setup() {");
    buffer.writeln(
        '    SaveData.instance.register("${klass.name}", ${klass.name}Provider());');
    buffer.writeln("  }");
    buffer.writeln("");
    buffer.writeln('  static Future<${klass.name}> load() async {');
    buffer.writeln('    return await SaveData.instance.load("${klass.name}");');
    buffer.writeln("  }");
    buffer.writeln("");
    buffer.writeln('  static Future<void> save() async {');
    buffer.writeln('    return await SaveData.instance.save("${klass.name}");');
    buffer.writeln("  }");
    buffer.writeln('}');
    return buffer.toString();
  }

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw new InvalidGenerationSourceError(
          "Content annotation is should be set to only class.");
    }
    ClassElement cl = element as ClassElement;
    final lib = Library((b) => b.body.add(Code(_generateProviderClass(cl))));
    final emitter = DartEmitter();
    return lib.accept(emitter).toString();
  }
}
