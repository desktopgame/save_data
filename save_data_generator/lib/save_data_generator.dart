import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator.dart';

Builder myBuilder(BuilderOptions options) =>
    LibraryBuilder(MyGenerator(), generatedExtension: ".save_data.dart");
