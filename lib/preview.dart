import 'dart:io';

import 'package:bulk_namer_hq/ai.dart';
import 'package:bulk_namer_hq/error.dart';
import 'package:bulk_namer_hq/files.dart';
import 'package:bulk_namer_hq/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preview.freezed.dart';
part 'preview.g.dart';

@freezed
class FilesChange with _$FilesChange {
  const FilesChange._();
  const factory FilesChange({
    required File file,
    required String newName,
    required bool isPatch,
  }) = _FilesChange;

  String get newNameWithExtension {
    final extension = p.extension(file.path);
    return '$newName$extension';
  }

  String get oldName => p.basenameWithoutExtension(file.path);

  String get oldNameWithExtension =>
      file.path.split(Platform.pathSeparator).last;
}

@riverpod
Result<List<FilesChange>> filesChange(Ref ref) {
  final patch = ref.watch(filesRenamePatchProvider);
  final files = ref.watch(filesProvider);
  final rrule = ref.watch(parseRuleProvider);

  if (!rrule.isSuccess) {
    return Failure(rrule.message!);
  }

  final rule = rrule.data!;

  final changes = <FilesChange>[];
  int i = 0;
  for (final file in files) {
    if (patch.containsKey(file)) {
      changes
          .add(FilesChange(file: file, newName: patch[file]!, isPatch: true));
      i++;
      continue;
    }
    final newName = rule.apply(i, p.basenameWithoutExtension(file.path));
    changes.add(FilesChange(file: file, newName: newName, isPatch: false));
    i++;
  }
  return Success(changes);
}

enum AIFileChangeStatus { idle, loading }

@freezed
class AIFileChangeState with _$AIFileChangeState {
  const AIFileChangeState._();
  const factory AIFileChangeState({
    required AIFileChangeStatus status,
    required Result<Map<File, String>>? result,
  }) = _AIFileChangeState;

  static AIFileChangeState initial() {
    return AIFileChangeState(status: AIFileChangeStatus.idle, result: null);
  }
}

@Riverpod(keepAlive: true)
class AIFileChanges extends _$AIFileChanges {
  @override
  AIFileChangeState build() {
    ref.watch(filesProvider);
    return AIFileChangeState.initial();
  }

  Future<void> update() async {
    if (state.status == AIFileChangeStatus.loading) {
      return;
    }
    state = state.copyWith(status: AIFileChangeStatus.loading);
    try {
      final changes = await getaiFileChanges(
          ref.read(filesProvider), ref.read(filesRenamePatchProvider));
      final data = <File, String>{};
      for (var i = 0; i < changes.length; i++) {
        data[ref.read(filesProvider)[i]] = changes[i];
      }
      state = AIFileChangeState(
          status: AIFileChangeStatus.idle, result: Success(data));
    } on Exception catch (e) {
      state = AIFileChangeState(
          status: AIFileChangeStatus.idle, result: Failure(e.toString()));
    }
  }
}

class FilesChangePreviewManual extends HookConsumerWidget {
  const FilesChangePreviewManual({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changes = ref.watch(filesChangeProvider);

    return switch (changes) {
      Success(:final data) => FilesChangePreview(
          changes: data,
        ),
      Failure(:final message) => Center(
          child: Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ),
        ),
    };
  }
}

@riverpod
List<FilesChange> aiFIleChangesMarge(Ref ref) {
  final patch = ref.watch(filesRenamePatchProvider);
  final files = ref.watch(filesProvider);
  final ai = ref.watch(aIFileChangesProvider);
  final res = <FilesChange>[];
  for (var i = 0; i < files.length; i++) {
    final file = files[i];
    if (patch.containsKey(file)) {
      res.add(FilesChange(
        file: file,
        newName: patch[file]!,
        isPatch: true,
      ));
    } else {
      res.add(FilesChange(
        file: file,
        newName: ai.result?.data?[file] ?? "",
        isPatch: false,
      ));
    }
  }
  return res;
}

class FilesChangePreviewSwich extends ConsumerWidget {
  const FilesChangePreviewSwich({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(changeModeProvider);
    return switch (mode) {
      ChangeModeEnum.manual => FilesChangePreviewManual(),
      ChangeModeEnum.ai => FilesChangePreviewAI(),
    };
  }
}

class FilesChangePreviewAI extends HookConsumerWidget {
  const FilesChangePreviewAI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(aiFIleChangesMargeProvider);
    return FilesChangePreview(changes: files);
  }
}

Future<void> applyNameChange(List<FilesChange> changes) async {
  for (final change in changes) {
    final oldPath = change.file.path;
    final newPath = p.join(p.dirname(oldPath), change.newNameWithExtension);
    await change.file.rename(newPath);
  }
}

class RenameButton extends HookConsumerWidget {
  final List<FilesChange> changes;

  const RenameButton({super.key, required this.changes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    final progress = useState(0.0);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: isProcessing.value
          ? Column(
              children: [
                LinearProgressIndicator(value: progress.value),
                const SizedBox(height: 8),
                Text('${(progress.value * 100).toInt()}% 完了'),
              ],
            )
          : FilledButton(
              onPressed: () async {
                isProcessing.value = true;
                try {
                  for (var i = 0; i < changes.length; i++) {
                    final oldPath = changes[i].file.path;
                    final newPath = p.join(
                        p.dirname(oldPath), changes[i].newNameWithExtension);
                    await changes[i].file.rename(newPath);
                    progress.value = (i + 1) / changes.length;
                  }
                  ref.read(filesProvider.notifier).clear();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ファイル名の変更が完了しました')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('エラーが発生しました: $e'),
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                      ),
                    );
                  }
                } finally {
                  isProcessing.value = false;
                  progress.value = 0.0;
                }
              },
              child: const Text('名前を変更'),
            ),
    );
  }
}

class FilesChangePreview extends HookConsumerWidget {
  final List<FilesChange> changes;

  const FilesChangePreview({
    required this.changes,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (changes.isEmpty) {
      return const Center(
        child: BigFileSelectButton(),
      );
    }
    final isDuplicate =
        Set<String>.from(changes.map((e) => e.newName)).length !=
            changes.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: changes.length,
            itemBuilder: (context, index) {
              final change = changes[index];
              final oldName =
                  change.file.path.split(Platform.pathSeparator).last;
              final newName = change.newNameWithExtension;

              return Card(
                child: InkWell(
                  onTap: () async {
                    final controller =
                        TextEditingController(text: change.newName);
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('個別に名前を編集'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('現在の名前: $oldName'),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                labelText: '新しい名前',
                                border: OutlineInputBorder(),
                              ),
                              autofocus: true,
                            ),
                          ],
                        ),
                        actions: [
                          if (change.isPatch)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(filesRenamePatchProvider.notifier)
                                    .remove(change.file);
                                Navigator.pop(context);
                              },
                              child: const Text('変更を削除'),
                            ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('キャンセル'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(context, controller.text),
                            child: const Text('変更'),
                          ),
                        ],
                      ),
                    );

                    if (result != null) {
                      ref
                          .read(filesRenamePatchProvider.notifier)
                          .set(change.file, result);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            oldName,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(178),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            newName,
                            style: TextStyle(
                              color: change.isPatch
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              fontWeight:
                                  change.isPatch ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (isDuplicate)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '重複する名前があります',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          )
        else
          RenameButton(changes: changes),
      ],
    );
  }
}
