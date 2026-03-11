import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../repositories/hobby_repository.dart';
import '../repositories/session_repository.dart';

class ExportPdf {
  final HobbyRepository _hobbyRepo;
  final SessionRepository _sessionRepo;

  ExportPdf(this._hobbyRepo, this._sessionRepo);

  Future<File> call({DateTime? from, DateTime? to}) async {
    final hobbies = await _hobbyRepo.getActiveHobbies();
    final hobbyMap = {for (final h in hobbies) h.id: h.name};

    final start = from ?? DateTime(2000);
    final end = to ?? DateTime.now().add(const Duration(days: 1));
    final sessions = await _sessionRepo.getSessionsInRange(start, end);

    final totalMin = sessions.fold<int>(0, (s, e) => s + e.durationMinutes);
    final perHobby = <String, int>{};
    for (final s in sessions) {
      final name = hobbyMap[s.hobbyId] ?? s.hobbyId;
      perHobby[name] = (perHobby[name] ?? 0) + s.durationMinutes;
    }

    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => [
        pw.Header(level: 0, text: 'Hobby Tracker Report'),
        pw.Paragraph(
          text:
              '${start.toIso8601String().split('T').first} — ${end.toIso8601String().split('T').first}',
        ),
        pw.Header(level: 1, text: 'Summary'),
        pw.Paragraph(text: 'Total sessions: ${sessions.length}'),
        pw.Paragraph(text: 'Total time: ${totalMin ~/ 60}h ${totalMin % 60}m'),
        pw.Paragraph(text: 'Active hobbies: ${hobbies.length}'),
        pw.Header(level: 1, text: 'Time per Hobby'),
        pw.TableHelper.fromTextArray(
          headers: ['Hobby', 'Minutes'],
          data: perHobby.entries
              .map((e) => [e.key, e.value.toString()])
              .toList(),
        ),
        pw.Header(level: 1, text: 'Session Log'),
        pw.TableHelper.fromTextArray(
          headers: ['Date', 'Hobby', 'Duration', 'Rating'],
          data: sessions
              .map((s) => [
                    s.date.toIso8601String().split('T').first,
                    hobbyMap[s.hobbyId] ?? s.hobbyId,
                    '${s.durationMinutes} min',
                    s.rating?.toString() ?? '-',
                  ])
              .toList(),
        ),
      ],
    ));

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/hobby_tracker_report.pdf');
    return file.writeAsBytes(await pdf.save());
  }
}
