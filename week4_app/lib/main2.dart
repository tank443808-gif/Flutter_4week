import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(NoticeApp(service: MockNoticeService()));
}

class Notice {
  const Notice({
    required this.title,
    required this.body,
    required this.date,
  });

  final String title;
  final String body;
  final String date;
}

abstract interface class NoticeService {
  int get requestCount;

  Future<List<Notice>> fetchNotices();

  void failNextRequest();
}

class MockNoticeService implements NoticeService {
  MockNoticeService({
    this.latency = const Duration(milliseconds: 500),
  });

  final Duration latency;
  int _requestCount = 0;
  bool _shouldFailNextRequest = false;

  static const List<Notice> _notices = [
    Notice(
      title: '4주차 과제 제출 안내',
      body: '로딩·성공·실패 화면과 재시도 동작을 확인하고 검증 기록을 제출해 주세요.',
      date: '2026. 10. 13.',
    ),
    Notice(
      title: '실습실 이용 안내',
      body: '실습 종료 후에는 사용한 장비를 정리하고 개인 자료를 저장해 주세요.',
      date: '2026. 10. 12.',
    ),
    Notice(
      title: 'Flutter 보충 학습 자료',
      body: 'Future와 Stream의 차이, await 전후의 실행 순서를 복습해 주세요.',
      date: '2026. 10. 10.',
    ),
  ];

  @override
  int get requestCount => _requestCount;

  @override
  Future<List<Notice>> fetchNotices() async {
    _requestCount++;
    await Future<void>.delayed(latency);

    if (_shouldFailNextRequest) {
      _shouldFailNextRequest = false;
      throw const NoticeServiceException('모의 요청이 실패했습니다.');
    }

    return List<Notice>.unmodifiable(_notices);
  }

  @override
  void failNextRequest() {
    _shouldFailNextRequest = true;
  }
}

class NoticeServiceException implements Exception {
  const NoticeServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NoticeApp extends StatelessWidget {
  const NoticeApp({super.key, required this.service});

  final NoticeService service;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '공지사항',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: NoticePage(service: service),
    );
  }
}

enum _NoticeStatus { idle, loading, success, failure }

class NoticePage extends StatefulWidget {
  const NoticePage({super.key, required this.service});

  final NoticeService service;

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  _NoticeStatus _status = _NoticeStatus.idle;
  List<Notice> _notices = const [];
  Object? _error;
  bool _requestInFlight = false;
  bool _failureScheduled = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadNotices());
  }

  Future<void> _loadNotices() async {
    if (_requestInFlight) return;

    _requestInFlight = true;
    setState(() {
      _status = _NoticeStatus.loading;
      _error = null;
      _failureScheduled = false;
    });

    try {
      final notices = await widget.service.fetchNotices();
      if (notices.isEmpty ||
          notices.any(
            (notice) =>
                notice.title.trim().isEmpty ||
                notice.body.trim().isEmpty ||
                notice.date.trim().isEmpty,
          )) {
        throw const FormatException('응답에 표시할 수 있는 공지 정보가 없습니다.');
      }

      if (!mounted) return;
      setState(() {
        _notices = notices;
        _status = _NoticeStatus.success;
      });
    } on Exception catch (error, stackTrace) {
      debugPrint('공지 요청 실패: $error\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _error = error;
        _status = _NoticeStatus.failure;
      });
    } finally {
      _requestInFlight = false;
    }
  }

  void _scheduleFailure() {
    widget.service.failNextRequest();
    setState(() {
      _failureScheduled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _status == _NoticeStatus.loading;

    return RepaintBoundary(
      key: const ValueKey('notice-screen'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('공지사항'),
          centerTitle: true,
          actions: [
            IconButton(
              key: const ValueKey('refresh-notices'),
              tooltip: '공지 새로고침',
              onPressed: isLoading ? null : _loadNotices,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: OutlinedButton.icon(
                key: const ValueKey('schedule-failure'),
                onPressed: isLoading ? null : _scheduleFailure,
                icon: const Icon(Icons.warning_amber),
                label: Text(
                  _failureScheduled ? '다음 요청 실패 예약됨' : '모의 실패 예약',
                ),
              ),
            ),
            Expanded(child: _buildContent()),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '요청 횟수: ${widget.service.requestCount}',
                key: const ValueKey('request-count'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return switch (_status) {
      _NoticeStatus.idle || _NoticeStatus.loading => const _LoadingView(),
      _NoticeStatus.success => _SuccessView(notices: _notices),
      _NoticeStatus.failure => _FailureView(
        error: _error,
        onRetry: _loadNotices,
      ),
    };
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('공지를 불러오는 중입니다.'),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.notices});

  final List<Notice> notices;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            '최근 공지',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        for (final notice in notices)
          Card(
            child: ListTile(
              leading: const Icon(Icons.campaign_outlined),
              title: Text(notice.title),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('${notice.body}\n${notice.date}'),
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 12),
            const Text(
              '공지를 불러오지 못했습니다.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const ValueKey('retry-notices'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}