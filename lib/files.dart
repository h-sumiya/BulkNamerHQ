import 'dart:io';

import 'package:bulk_namer_hq/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'files.g.dart';

@Riverpod(keepAlive: true)
class Files extends _$Files {
  @override
  List<File> build() {
    return [];
  }

  Future<void> pick() async {
    final files = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (files != null) {
      final newState = files.files.map((e) => File(e.path!)).toList();
      fileSmartSort(newState);
      state = newState;
    }
  }

  void clear() {
    state = [];
  }
}

@Riverpod(keepAlive: true)
class FilesRenamePatch extends _$FilesRenamePatch {
  @override
  Map<File, String> build() {
    ref.watch(filesProvider);
    return {};
  }

  void set(File file, String newName) {
    state = {...state, file: newName};
  }

  void remove(File file) {
    state = {...state}..remove(file);
  }
}

class FileSelectButton extends HookConsumerWidget {
  const FileSelectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        Icons.file_open_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () => ref.read(filesProvider.notifier).pick(),
    );
  }
}

class BigFileSelectButton extends HookConsumerWidget {
  const BigFileSelectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(filesProvider.notifier).pick(),
      child: Text('ファイルを選択'),
    );
  }
}
