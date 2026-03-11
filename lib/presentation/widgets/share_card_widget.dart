import 'package:flutter/material.dart';

import '../../domain/entities/share_progress_card.dart';
import '../../l10n/app_localizations.dart';

class ShareCardWidget extends StatelessWidget {
  final ShareProgressCard card;
  const ShareCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (card.badgeEmoji != null) ...[
            Text(card.badgeEmoji!, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 4),
            Text(card.badgeTitle ?? '',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 12),
          ],
          Text(card.hobbyName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(card.category,
              style: const TextStyle(color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stat('🔥', '${card.streakDays}', l.streak),
              _Stat('📝', '${card.totalSessions}', l.sessions),
              _Stat('⏱️', '${card.totalMinutes}m', l.totalTime),
            ],
          ),
          const SizedBox(height: 16),
          Text('Hobby Tracker',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  const _Stat(this.emoji, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}
