import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Lab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('프로필 화면'),
              centerTitle: true,
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // TODO(AC1): 프로필 머리말 구성
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '장도겸',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.school, size: 18, color: Colors.grey),
                            SizedBox(width: 6),
                            Text('컴퓨터소프트웨어과'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // TODO(AC2): 카드형 정보 목록
                _InfoCard(
                  title: '관심 분야',
                  icon: Icons.favorite,
                  details: ['Flutter UI', '모바일 앱 개발', 'UX 디자인'],
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: '이번 주 목표',
                  icon: Icons.flag,
                  details: ['위젯 조합 연습', '프로필 화면 완성', '피드백 반영'],
                ),
                const SizedBox(height: 12),
                _InfoCard(
                  title: '연락 방법',
                  icon: Icons.mail,
                  details: ['email: tank443808@g.shingu.ac.kr', 'GitHub:  tank443808-gif'],
                ),

                const SizedBox(height: 20),

                // TODO(AC3): 확인 버튼과 SnackBar
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('프로필을 확인했습니다'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('프로필 확인'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.details,
  });

  final String title;
  final IconData icon;
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...details.map(
              (detail) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(detail)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
