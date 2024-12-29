// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FilesChange {
  File get file => throw _privateConstructorUsedError;
  String get newName => throw _privateConstructorUsedError;
  bool get isPatch => throw _privateConstructorUsedError;

  /// Create a copy of FilesChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilesChangeCopyWith<FilesChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilesChangeCopyWith<$Res> {
  factory $FilesChangeCopyWith(
          FilesChange value, $Res Function(FilesChange) then) =
      _$FilesChangeCopyWithImpl<$Res, FilesChange>;
  @useResult
  $Res call({File file, String newName, bool isPatch});
}

/// @nodoc
class _$FilesChangeCopyWithImpl<$Res, $Val extends FilesChange>
    implements $FilesChangeCopyWith<$Res> {
  _$FilesChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilesChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = null,
    Object? newName = null,
    Object? isPatch = null,
  }) {
    return _then(_value.copyWith(
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File,
      newName: null == newName
          ? _value.newName
          : newName // ignore: cast_nullable_to_non_nullable
              as String,
      isPatch: null == isPatch
          ? _value.isPatch
          : isPatch // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilesChangeImplCopyWith<$Res>
    implements $FilesChangeCopyWith<$Res> {
  factory _$$FilesChangeImplCopyWith(
          _$FilesChangeImpl value, $Res Function(_$FilesChangeImpl) then) =
      __$$FilesChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({File file, String newName, bool isPatch});
}

/// @nodoc
class __$$FilesChangeImplCopyWithImpl<$Res>
    extends _$FilesChangeCopyWithImpl<$Res, _$FilesChangeImpl>
    implements _$$FilesChangeImplCopyWith<$Res> {
  __$$FilesChangeImplCopyWithImpl(
      _$FilesChangeImpl _value, $Res Function(_$FilesChangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of FilesChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? file = null,
    Object? newName = null,
    Object? isPatch = null,
  }) {
    return _then(_$FilesChangeImpl(
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File,
      newName: null == newName
          ? _value.newName
          : newName // ignore: cast_nullable_to_non_nullable
              as String,
      isPatch: null == isPatch
          ? _value.isPatch
          : isPatch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FilesChangeImpl extends _FilesChange {
  const _$FilesChangeImpl(
      {required this.file, required this.newName, required this.isPatch})
      : super._();

  @override
  final File file;
  @override
  final String newName;
  @override
  final bool isPatch;

  @override
  String toString() {
    return 'FilesChange(file: $file, newName: $newName, isPatch: $isPatch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilesChangeImpl &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.newName, newName) || other.newName == newName) &&
            (identical(other.isPatch, isPatch) || other.isPatch == isPatch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, file, newName, isPatch);

  /// Create a copy of FilesChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilesChangeImplCopyWith<_$FilesChangeImpl> get copyWith =>
      __$$FilesChangeImplCopyWithImpl<_$FilesChangeImpl>(this, _$identity);
}

abstract class _FilesChange extends FilesChange {
  const factory _FilesChange(
      {required final File file,
      required final String newName,
      required final bool isPatch}) = _$FilesChangeImpl;
  const _FilesChange._() : super._();

  @override
  File get file;
  @override
  String get newName;
  @override
  bool get isPatch;

  /// Create a copy of FilesChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilesChangeImplCopyWith<_$FilesChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AIFileChangeState {
  AIFileChangeStatus get status => throw _privateConstructorUsedError;
  Result<Map<File, String>>? get result => throw _privateConstructorUsedError;

  /// Create a copy of AIFileChangeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIFileChangeStateCopyWith<AIFileChangeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIFileChangeStateCopyWith<$Res> {
  factory $AIFileChangeStateCopyWith(
          AIFileChangeState value, $Res Function(AIFileChangeState) then) =
      _$AIFileChangeStateCopyWithImpl<$Res, AIFileChangeState>;
  @useResult
  $Res call({AIFileChangeStatus status, Result<Map<File, String>>? result});
}

/// @nodoc
class _$AIFileChangeStateCopyWithImpl<$Res, $Val extends AIFileChangeState>
    implements $AIFileChangeStateCopyWith<$Res> {
  _$AIFileChangeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIFileChangeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? result = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AIFileChangeStatus,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result<Map<File, String>>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIFileChangeStateImplCopyWith<$Res>
    implements $AIFileChangeStateCopyWith<$Res> {
  factory _$$AIFileChangeStateImplCopyWith(_$AIFileChangeStateImpl value,
          $Res Function(_$AIFileChangeStateImpl) then) =
      __$$AIFileChangeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AIFileChangeStatus status, Result<Map<File, String>>? result});
}

/// @nodoc
class __$$AIFileChangeStateImplCopyWithImpl<$Res>
    extends _$AIFileChangeStateCopyWithImpl<$Res, _$AIFileChangeStateImpl>
    implements _$$AIFileChangeStateImplCopyWith<$Res> {
  __$$AIFileChangeStateImplCopyWithImpl(_$AIFileChangeStateImpl _value,
      $Res Function(_$AIFileChangeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIFileChangeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? result = freezed,
  }) {
    return _then(_$AIFileChangeStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AIFileChangeStatus,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result<Map<File, String>>?,
    ));
  }
}

/// @nodoc

class _$AIFileChangeStateImpl extends _AIFileChangeState {
  const _$AIFileChangeStateImpl({required this.status, required this.result})
      : super._();

  @override
  final AIFileChangeStatus status;
  @override
  final Result<Map<File, String>>? result;

  @override
  String toString() {
    return 'AIFileChangeState(status: $status, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIFileChangeStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, result);

  /// Create a copy of AIFileChangeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIFileChangeStateImplCopyWith<_$AIFileChangeStateImpl> get copyWith =>
      __$$AIFileChangeStateImplCopyWithImpl<_$AIFileChangeStateImpl>(
          this, _$identity);
}

abstract class _AIFileChangeState extends AIFileChangeState {
  const factory _AIFileChangeState(
          {required final AIFileChangeStatus status,
          required final Result<Map<File, String>>? result}) =
      _$AIFileChangeStateImpl;
  const _AIFileChangeState._() : super._();

  @override
  AIFileChangeStatus get status;
  @override
  Result<Map<File, String>>? get result;

  /// Create a copy of AIFileChangeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIFileChangeStateImplCopyWith<_$AIFileChangeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
