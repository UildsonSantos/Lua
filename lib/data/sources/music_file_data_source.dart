import 'package:lua/data/models/models.dart';
import 'package:path_provider/path_provider.dart';

class MusicFileDataSource {
  Future<List<SongModel>> getLocalSongs() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final musicFiles = directory
          .listSync()
          .where((file) => file.path.endsWith('.mp3'))
          .toList();
      return musicFiles.map((file) {
        return SongModel(
          id: file.uri.toString(),
          title: file.uri.pathSegments.last,
          filePath: file.path,
          artist: '',
          album: '',
          duration: 0,
        );
      }).toList();
    } else {
      throw Exception('Diretório não encontrado');
    }
  }
}
