class DirectoryModel {
  final int id;
  final String path;
  final int folderCount;
  final int fileCount;

  DirectoryModel({
    required this.id,
    required this.path,
    required this.folderCount,
    required this.fileCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'folderCount': folderCount,
      'fileCount': fileCount,
    };
  }
}
