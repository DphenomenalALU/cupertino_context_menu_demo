import 'package:flutter/cupertino.dart';

bool get demoUseCustomPreviewBuilder => true;
bool get demoShowTrailingIcons => true;
bool get demoDeleteIsDestructive => true;

void main() {
  runApp(const CupertinoContextMenuDemoApp());
}

class CupertinoContextMenuDemoApp extends StatelessWidget {
  const CupertinoContextMenuDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Cupertino Context Menu Demo',
      home: ChatsHomePage(),
    );
  }
}

class ChatsHomePage extends StatefulWidget {
  const ChatsHomePage({super.key});

  @override
  State<ChatsHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  final List<_ChatThread> _threads = List.generate(
    8,
    (i) => _ChatThread(
      id: i + 1,
      name: _ChatThread._names[i % _ChatThread._names.length],
      lastMessage: _ChatThread._messages[i % _ChatThread._messages.length],
      unreadCount: (i % 3 == 0) ? (i % 5) + 1 : 0,
    ),
  );

  void _pinThread(_ChatThread thread) {
    setState(() {
      thread.pinned = !thread.pinned;
      _threads.sort((a, b) {
        final pinnedCompare = (b.pinned ? 1 : 0).compareTo(a.pinned ? 1 : 0);
        return pinnedCompare != 0 ? pinnedCompare : a.name.compareTo(b.name);
      });
    });
  }

  void _muteThread(_ChatThread thread) {
    setState(() {
      thread.muted = !thread.muted;
    });
  }

  void _deleteThread(_ChatThread thread) {
    setState(() {
      _threads.removeWhere((t) => t.id == thread.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Chats'),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Long-press a chat row to open the iOS-style context menu.',
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: _threads.length,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 76),
                    child: Container(
                      height: 1,
                      color: CupertinoColors.separator.resolveFrom(context),
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  final thread = _threads[index];
                  final row = _ChatRow(thread: thread);
                  final actions = <Widget>[
                    CupertinoContextMenuAction(
                      isDefaultAction: true,
                      trailingIcon:
                          demoShowTrailingIcons ? CupertinoIcons.pin : null,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _pinThread(thread);
                      },
                      child: Text(thread.pinned ? 'Unpin' : 'Pin'),
                    ),
                    CupertinoContextMenuAction(
                      trailingIcon: demoShowTrailingIcons
                          ? (thread.muted
                              ? CupertinoIcons.bell
                              : CupertinoIcons.bell_slash)
                          : null,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _muteThread(thread);
                      },
                      child: Text(thread.muted ? 'Unmute' : 'Mute'),
                    ),
                    CupertinoContextMenuAction(
                      isDestructiveAction: demoDeleteIsDestructive,
                      trailingIcon:
                          demoShowTrailingIcons ? CupertinoIcons.trash : null,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteThread(thread);
                      },
                      child: const Text('Delete'),
                    ),
                  ];

                  if (!demoUseCustomPreviewBuilder) {
                    return CupertinoContextMenu(
                      actions: actions,
                      child: row,
                    );
                  }

                  return CupertinoContextMenu.builder(
                    actions: actions,
                    builder: (context, animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, _) {
                          final openInterval = CurvedAnimation(
                            parent: animation,
                            curve: Interval(
                              CupertinoContextMenu.animationOpensAt,
                              1,
                            ),
                          );
                          final borderRadius =
                              BorderRadiusTween(
                                begin: BorderRadius.circular(14),
                                end: BorderRadius.circular(
                                  CupertinoContextMenu.kOpenBorderRadius,
                                ),
                              ).transform(openInterval.value)!;

                          final shadowOpacity = openInterval.value;
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 24,
                                  spreadRadius: -6,
                                  offset: const Offset(0, 12),
                                  color: CupertinoColors.black.withOpacity(
                                    0.25 * shadowOpacity,
                                  ),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: borderRadius,
                              child: _ChatPreviewCard(
                                thread: thread,
                                child: row,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatThread {
  _ChatThread({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unreadCount,
  });

  final int id;
  final String name;
  final String lastMessage;
  final int unreadCount;
  bool pinned = false;
  bool muted = false;

  static const List<String> _names = [
    'Ava',
    'Ben',
    'Carmen',
    'Dylan',
    'Eli',
    'Fatima',
    'Gabe',
    'Hana',
  ];

  static const List<String> _messages = [
    'Are we still on for tonight?',
    'I sent the document—take a look.',
    'On my way!',
    'Can you review this PR?',
    'Let’s grab coffee after class.',
    'That sounds good to me.',
  ];
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.thread});

  final _ChatThread thread;

  @override
  Widget build(BuildContext context) {
    final subtitle = thread.muted
        ? '${thread.lastMessage}  •  Muted'
        : thread.lastMessage;
    return Container(
      color: CupertinoColors.systemBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _Avatar(name: thread.name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        thread.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (thread.pinned) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        CupertinoIcons.pin,
                        size: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          if (thread.unreadCount > 0) ...[
            const SizedBox(width: 12),
            _UnreadBadge(count: thread.unreadCount),
          ],
        ],
      ),
    );
  }
}

class _ChatPreviewCard extends StatelessWidget {
  const _ChatPreviewCard({required this.thread, required this.child});

  final _ChatThread thread;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        Container(
          width: double.infinity,
          color: CupertinoColors.secondarySystemBackground,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.label,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preview',
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 8),
                Text('• ${thread.lastMessage}'),
                const SizedBox(height: 4),
                Text('• (Earlier) “See you soon.”'),
                const SizedBox(height: 4),
                Text('• (Earlier) “Got it, thanks!”'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final background = _colorFor(name);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: Text(
        name.characters.first.toUpperCase(),
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _colorFor(String input) {
    const colors = [
      CupertinoColors.activeBlue,
      CupertinoColors.activeGreen,
      CupertinoColors.activeOrange,
      CupertinoColors.systemPurple,
      CupertinoColors.systemPink,
      CupertinoColors.systemTeal,
    ];
    final index =
        input.codeUnits.fold<int>(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemRed,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
