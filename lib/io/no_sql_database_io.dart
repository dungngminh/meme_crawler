abstract class NoSqlDatabaseIo<T> {
  Future<void> initialize() {
    return Future.value();
  }

  Future<void> saveAll({
    required String databaseId,
    required String collectionId,
    required List<T> data,
  });

  Future<void> save({
    required String databaseId,
    required String collectionId,
    required T data,
  });

  Future<T?> isExist({
    required String databaseId,
    required String collectionId,
    required T data,
  });

  Future<bool> delete({
    required String databaseId,
    required String collectionId,
    required T data,
  });
}
