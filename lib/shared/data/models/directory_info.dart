class DirectoryInfo {
  final int? id;
  final String path;
  final String type;
  final String? parentId;
  final bool isFavorite;
  final String? name;
  int fileCount;
  int folderCount;

  DirectoryInfo({
    this.id,
    required this.path,
    required this.type,
    this.parentId,
    this.isFavorite = false,
    this.name,
    this.fileCount = 0,
    this.folderCount = 0,
  });

  factory DirectoryInfo.fromMap(Map<String, dynamic> map) {
    return DirectoryInfo(
      id: map['id'],
      path: map['path'],
      type: map['type'],
      parentId: map['parentId'],
      isFavorite: map['isFavorite'] ?? false,
      name: map['name'],
      fileCount: map['fileCount'] ?? 0,
      folderCount: map['folderCount'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'DirectoryInfo(id: $id, path: $path, type: $type, parentId: $parentId, isFavorite: $isFavorite, name: $name, fileCount: $fileCount, folderCount: $folderCount)';
  }

  DirectoryInfo copyWith({
    int? id,
    String? path,
    String? type,
    String? parentId,
    bool? isFavorite,
    String? name,
    int? fileCount,
    int? folderCount,
  }) {
    return DirectoryInfo(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      isFavorite: isFavorite ?? this.isFavorite,
      name: name ?? this.name,
      fileCount: fileCount ?? this.fileCount,
      folderCount: folderCount ?? this.folderCount,
    );
  }
}
