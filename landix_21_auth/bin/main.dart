import 'package:landix_21_auth/landix_21_auth.dart';

Future main() async {
  final app = Application<Landix21AuthChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;
    
  //final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: 4);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}