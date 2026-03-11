import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _PageData(
      icon: Icons.sports_esports,
      title: 'Track Your Hobbies',
      body: 'Log sessions, set goals, and watch your progress grow over time.',
    ),
    _PageData(
      icon: Icons.emoji_events,
      title: 'Earn Badges & Streaks',
      body: 'Stay motivated with achievements, streaks, and milestone badges.',
    ),
    _PageData(
      icon: Icons.cloud_sync,
      title: 'Sync & Export',
      body: 'Back up to the cloud and export your data as CSV or PDF anytime.',
    ),
  ];

  Future<void> _finish() async {
    await sl<SharedPreferences>().setBool('onboarding_done', true);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(p.icon, size: 100,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 32),
                        Text(p.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(p.body,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => Container(
                  margin: const EdgeInsets.all(4),
                  width: _page == i ? 12 : 8,
                  height: _page == i ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _page == i
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: const Text('Skip'),
                  ),
                  ElevatedButton(
                    onPressed: _page == _pages.length - 1
                        ? _finish
                        : () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                    child: Text(
                        _page == _pages.length - 1 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final String title;
  final String body;
  const _PageData({required this.icon, required this.title, required this.body});
}
