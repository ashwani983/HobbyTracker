import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../repositories/hobby_repository.dart';
import '../repositories/session_repository.dart';

class ExportCsv {
  final HobbyRepository _hobbyRepo;
  final SessionRepository _sessionRepo;

  ExportCsv(this._hobbyRepo, this._sessionRepo);

  Future<File> call({DateTime? from, DateTime? to}) async {
    final hobbies = await _hobbyRepo.getActiveHobbies();
    final hobbyMap = {for (final h in hobbies) h.id: h.name};

    final start = from ?? DateTime(2000);
    final end = to ?? DateTime.now().add(const Duration(days: 1));
    final sessions = await _sessionRepo.getSessionsInRange(start, end);

    final rows = <List<String>>[
      ['Date', 'Hobby', 'Duration (min)', 'Rating', 'Notes'],
      ...sessions.map((s) => [
            s.date.toIso8601String().split('T').first,
            hobbyMap[s.hobbyId] ?? s.hobbyId,
            s.durationMinutes.toString(),
            s.rating?.toString() ?? '',
            s.notes ?? '',
          ]),
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/hobby_tracker_export.csv');
    return file.writeAsString(csv);
  }
}
