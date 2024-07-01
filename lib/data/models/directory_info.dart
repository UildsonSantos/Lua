class DirectoryInfo {
  final String path;
  final int fileCount;
  final int folderCount;
  final bool isFavorite;

  DirectoryInfo({
    required this.path,
    required this.fileCount,
    required this.folderCount,
    this.isFavorite = false,
  });

  @override
  String toString() {
    return 'DirectoryInfo(path: $path, files: $fileCount, directories: $folderCount)';
  }

  DirectoryInfo copyWith({
    String? path,
    int? fileCount,
    int? folderCount,
    bool? isFavorite,
  }) {
    return DirectoryInfo(
      path: path ?? this.path,
      fileCount: fileCount ?? this.fileCount,
      folderCount: folderCount ?? this.folderCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
