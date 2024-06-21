import 'package:lua/domain/repositories/repositories.dart';

class RequestPermission {
  final FileRepository repository;

  RequestPermission(this.repository);

  Future<bool> call() {
    return repository.requestPermission();
  }
}
