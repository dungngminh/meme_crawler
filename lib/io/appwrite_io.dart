import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:myapp/io/no_sql_database_io.dart';
import 'package:myapp/model/meme_template.dart';

class AppwriteIo extends NoSqlDatabaseIo<MemeTemplate> {
  final Databases _databases;
  AppwriteIo({
    required Databases databases,
  }) : _databases = databases;

  @override
  Future<void> saveAll({
    required String databaseId,
    required String collectionId,
    required List<MemeTemplate> data,
  }) async {
    for (final memeTemplate in data) {
      try {
        _save(
          databaseId: databaseId,
          collectionId: collectionId,
          memeTemplate: memeTemplate,
        );
      } catch (e) {
        print(
            "❌ Exception occured in memeTemplate \"${memeTemplate.title}\": detail: $e");
        continue;
      }
    }
  }

  @override
  Future<void> save({
    required String databaseId,
    required String collectionId,
    required MemeTemplate data,
  }) {
    return isExist(
      databaseId: databaseId,
      collectionId: collectionId,
      data: data,
    ).then(
      (exist) {
        if (exist == null) {
          print("✅ No \"${data.title}\" from database, starting save action, data: ${data.toJson()}");
          return _save(
            databaseId: databaseId,
            collectionId: collectionId,
            memeTemplate: data,
          );
        } else {
          print("❌ \"${data.title}\" already exist in database");
          print("✅ Start deleting \"${data.title}\" from database");
          return delete(
            databaseId: databaseId,
            collectionId: collectionId,
            data: exist,
          ).then((value) {
            if (value) {
              return _save(
                databaseId: databaseId,
                collectionId: collectionId,
                memeTemplate: data,
              );
            } else {
              return Future.value();
            }
          });
        }
      },
    );
  }

  Future<void> _save({
    required String databaseId,
    required String collectionId,
    required MemeTemplate memeTemplate,
  }) =>
      _databases
          .createDocument(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: memeTemplate.id,
            data: memeTemplate.toJson(),
          )
          .then(
            (value) => print("✅ Saved \"${memeTemplate.title}\" successfully"),
          )
          .onError(
            (error, stackTrace) => print(
                "❌ Failed to save \"${memeTemplate.title}\" with error: $error"),
          );

  @override
  Future<MemeTemplate?> isExist({
    required String databaseId,
    required String collectionId,
    required MemeTemplate data,
  }) async {
    print("⏳ Start to check data is existed in DB: $data");
    return _databases.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
      queries: [
        Query.contains('title', [data.title]),
        Query.equal('originalImageUrl', [data.originalImageUrl]),
        Query.equal('detailUrl', [data.detailUrl]),
      ],
    ).then((response) {
      final document = response.documents.firstOrNull;
      if (document != null) {
        print("✅ Found an existed document: $document");
        return MemeTemplate.fromJson(document.data);
      }
      return null;
    }).onError((error, stackTrace) {
      print("❌ ❌ Failed to check exist in database with error: $error");
      return null;
    });
  }

  @override
  Future<bool> delete({
    required String databaseId,
    required String collectionId,
    required MemeTemplate data,
  }) {
    return _databases
        .deleteDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: data.id,
    )
        .then((value) {
      print("✅ Deleted ${data.title} successfully");
      return true;
    }).onError((error, stackTrace) {
      print("❌ ❌ Failed to delete document with error: $error");
      return false;
    });
  } 
}
