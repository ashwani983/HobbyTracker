import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AttachPhotos {
  final _picker = ImagePicker();

  Future<List<String>> fromGallery({int maxImages = 5}) async {
    final images = await _picker.pickMultiImage(limit: maxImages);
    return _saveAll(images);
  }

  Future<String?> fromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    final saved = await _saveAll([image]);
    return saved.firstOrNull;
  }

  Future<List<String>> _saveAll(List<XFile> files) async {
    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'session_photos'));
    if (!photoDir.existsSync()) photoDir.createSync(recursive: true);

    final paths = <String>[];
    for (final file in files) {
      final ext = p.extension(file.path);
      final dest = p.join(photoDir.path, '${DateTime.now().microsecondsSinceEpoch}$ext');
      await File(file.path).copy(dest);
      paths.add(dest);
    }
    return paths;
  }

  static Future<void> deletePhotos(List<String> paths) async {
    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
  }
}
