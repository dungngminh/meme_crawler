import 'package:dart_appwrite/dart_appwrite.dart';

class DependenceProvider {
  static Client provieClient({
    String endpoint = 'https://cloud.appwrite.io/v1',
    required String project,
    required String key,
  }) =>
      Client()
        ..setEndpoint(endpoint)
        ..setProject(project)
        ..setKey(key)
        ..setSelfSigned();

  static Databases provieDatabase({
    required Client client,
  }) =>
      Databases(client);
}
