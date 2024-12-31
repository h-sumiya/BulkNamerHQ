import 'package:bulk_namer_hq/error.dart';
import 'package:bulk_namer_hq/files.dart';
import 'package:bulk_namer_hq/preview.dart';
import 'package:bulk_namer_hq/rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'input.g.dart';

@Riverpod(keepAlive: true)
class RuleStr extends _$RuleStr {
  @override
  String build() {
    return '';
  }

  void update(String value) {
    state = value;
  }
}

enum ChangeModeEnum { manual, ai }

@Riverpod(keepAlive: true)
class ChangeMode extends _$ChangeMode {
  @override
  ChangeModeEnum build() {
    return ChangeModeEnum.manual;
  }

  void toggle() {
    state = state == ChangeModeEnum.manual
        ? ChangeModeEnum.ai
        : ChangeModeEnum.manual;
  }
}

@riverpod
Result<Rule> parseRule(Ref ref) {
  final ruleStr = ref.watch(ruleStrProvider);
  try {
    return Success(Rule.parse(ruleStr));
  } catch (e) {
    return Failure(e.toString());
  }
}

class RuleForm extends HookConsumerWidget {
  const RuleForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeMode = ref.watch(changeModeProvider);
    return switch (changeMode) {
      ChangeModeEnum.manual => ManualForm(),
      ChangeModeEnum.ai => AIForm(),
    };
  }
}

class SrcPopup extends HookWidget {
  final void Function(String) onApply;

  const SrcPopup({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final isNfkc = useState(false);
    final start = useState(0);
    final end = useState<int?>(null);
    final range = useState(false);
    final startController = useTextEditingController();
    final endController = useTextEditingController();

    String getRule() {
      final rule = isNfkc.value ? 'nfkc_src' : 'src';
      if (range.value) {
        return '$rule[${start.value}:${end.value ?? ''}]';
      } else {
        return rule;
      }
    }

    return AlertDialog(
      title: const Text('元の文字列を使用する'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text('正規化 (NFKC)'),
              value: isNfkc.value,
              onChanged: (value) => isNfkc.value = value!,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('切り取り'),
              value: range.value,
              onChanged: (value) => range.value = value!,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (range.value) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: startController,
                      decoration: const InputDecoration(
                        labelText: '開始位置',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) return;
                        try {
                          start.value = int.parse(value).clamp(1, 999999);
                          startController.text = start.value.toString();
                        } catch (e) {
                          startController.text = start.value.toString();
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: endController,
                      decoration: const InputDecoration(
                        labelText: '終了位置',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          end.value = null;
                          return;
                        }
                        try {
                          end.value = int.parse(value).clamp(1, 999999);
                          endController.text = end.value?.toString() ?? '';
                        } catch (e) {
                          endController.text = end.value?.toString() ?? '';
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: () => onApply(getRule()),
          child: const Text('適用'),
        ),
      ],
    );
  }
}

class IndexPopup extends HookWidget {
  final void Function(String) onApply;

  const IndexPopup({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final start = useState(1);
    final step = useState(1);
    final padding = useState<int?>(null);
    final startController = useTextEditingController(text: '1');
    final stepController = useTextEditingController(text: '1');
    final paddingController = useTextEditingController();

    String getRule() {
      String rule = 'num';

      if (padding.value != null) {
        rule += ':${padding.value}';
      }
      if (start.value != 1 || step.value != 1) {
        rule += '[${start.value}:${step.value}]';
      }
      return rule;
    }

    return AlertDialog(
      title: const Text('連番を挿入'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startController,
                    decoration: const InputDecoration(
                      labelText: '開始値',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      try {
                        start.value = int.parse(value);
                      } catch (e) {
                        startController.text = start.value.toString();
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: stepController,
                    decoration: const InputDecoration(
                      labelText: 'ステップ',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      try {
                        step.value = int.parse(value);
                      } catch (e) {
                        stepController.text = step.value.toString();
                      }
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: paddingController,
              decoration: const InputDecoration(
                labelText: 'パディング (桁数)',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  padding.value = null;
                  return;
                }
                try {
                  padding.value = int.parse(value);
                } catch (e) {
                  paddingController.text = padding.value?.toString() ?? '';
                }
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: () => onApply(getRule()),
          child: const Text('適用'),
        ),
      ],
    );
  }
}

class ManualForm extends HookConsumerWidget {
  const ManualForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController =
        useTextEditingController(text: ref.read(ruleStrProvider));
    final ruleResult = ref.watch(parseRuleProvider);

    void insert(String rawValue) {
      final value = '{$rawValue}';
      final currentPosition = textController.selection.start.clamp(0, textController.text.length);
      final text = textController.text;
      final newText = text.substring(0, currentPosition) +
          value +
          text.substring(currentPosition);
      textController.value = TextEditingValue(
        text: newText,
        selection:
            TextSelection.collapsed(offset: currentPosition + value.length),
      );
      ref.read(ruleStrProvider.notifier).update(newText);
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'リネームルール',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => ref.read(changeModeProvider.notifier).toggle(),
                  icon: const Icon(Icons.switch_access_shortcut),
                  label: const Text('AIモードへ切り替え'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              onChanged: (value) =>
                  ref.read(ruleStrProvider.notifier).update(value),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '例: prefix_{src}_{num:3}',
                errorText: switch (ruleResult) {
                  Success() => null,
                  Failure(:final message) => message,
                },
                helperText: '変数は { } で囲んで使用します',
                helperMaxLines: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '変数を挿入',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.text_fields, size: 18),
                      SizedBox(width: 4),
                      Text('元の文字列'),
                    ],
                  ),
                  onSelected: (_) {
                    showDialog(
                      context: context,
                      builder: (context) => SrcPopup(
                        onApply: (value) {
                          insert(value);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  selected: false,
                ),
                FilterChip(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.numbers, size: 18),
                      SizedBox(width: 4),
                      Text('連番'),
                    ],
                  ),
                  onSelected: (_) {
                    showDialog(
                      context: context,
                      builder: (context) => IndexPopup(
                        onApply: (value) {
                          insert(value);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  selected: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AIForm extends HookConsumerWidget {
  const AIForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (status, error) = ref.watch(
        aIFileChangesProvider.select((s) => (s.status, s.result?.message)));
    final patch = ref.watch(filesRenamePatchProvider.select((s) => s.length));
    
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'AIによるリネーム',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => ref.read(changeModeProvider.notifier).toggle(),
                  icon: const Icon(Icons.switch_access_shortcut),
                  label: const Text('手動モードへ切り替え'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'AIに変更の例を学習させて、まとめて変更します。'
              '\n1つ以上のファイルを選択して変更例を作成してください。',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (patch == 0)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("1つ以上の例が必要です"),
                ),
              )
            else
              Center(
                child: switch (status) {
                  AIFileChangeStatus.idle => FilledButton.icon(
                      onPressed: () {
                        ref.read(aIFileChangesProvider.notifier).update();
                      },
                      icon: const Icon(Icons.auto_fix_high),
                      label: const Text("AIで変更")),
                  AIFileChangeStatus.loading => const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                },
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
