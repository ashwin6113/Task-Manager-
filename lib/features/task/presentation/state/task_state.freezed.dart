// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TaskState {
  TaskStatus get status => throw _privateConstructorUsedError;
  List<TaskEntity> get tasks => throw _privateConstructorUsedError;
  List<TaskEntity> get displayTasks => throw _privateConstructorUsedError;
  int get skip => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  String get filter => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  bool get sortAscending => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskStateCopyWith<TaskState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStateCopyWith<$Res> {
  factory $TaskStateCopyWith(TaskState value, $Res Function(TaskState) then) =
      _$TaskStateCopyWithImpl<$Res, TaskState>;
  @useResult
  $Res call(
      {TaskStatus status,
      List<TaskEntity> tasks,
      List<TaskEntity> displayTasks,
      int skip,
      int limit,
      int total,
      bool hasReachedMax,
      String searchQuery,
      String filter,
      String sortBy,
      bool sortAscending,
      String? errorMessage});
}

/// @nodoc
class _$TaskStateCopyWithImpl<$Res, $Val extends TaskState>
    implements $TaskStateCopyWith<$Res> {
  _$TaskStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? tasks = null,
    Object? displayTasks = null,
    Object? skip = null,
    Object? limit = null,
    Object? total = null,
    Object? hasReachedMax = null,
    Object? searchQuery = null,
    Object? filter = null,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskEntity>,
      displayTasks: null == displayTasks
          ? _value.displayTasks
          : displayTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskEntity>,
      skip: null == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as String,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskStateImplCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$$TaskStateImplCopyWith(
          _$TaskStateImpl value, $Res Function(_$TaskStateImpl) then) =
      __$$TaskStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TaskStatus status,
      List<TaskEntity> tasks,
      List<TaskEntity> displayTasks,
      int skip,
      int limit,
      int total,
      bool hasReachedMax,
      String searchQuery,
      String filter,
      String sortBy,
      bool sortAscending,
      String? errorMessage});
}

/// @nodoc
class __$$TaskStateImplCopyWithImpl<$Res>
    extends _$TaskStateCopyWithImpl<$Res, _$TaskStateImpl>
    implements _$$TaskStateImplCopyWith<$Res> {
  __$$TaskStateImplCopyWithImpl(
      _$TaskStateImpl _value, $Res Function(_$TaskStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? tasks = null,
    Object? displayTasks = null,
    Object? skip = null,
    Object? limit = null,
    Object? total = null,
    Object? hasReachedMax = null,
    Object? searchQuery = null,
    Object? filter = null,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$TaskStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskEntity>,
      displayTasks: null == displayTasks
          ? _value._displayTasks
          : displayTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskEntity>,
      skip: null == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as String,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TaskStateImpl implements _TaskState {
  const _$TaskStateImpl(
      {this.status = TaskStatus.initial,
      final List<TaskEntity> tasks = const [],
      final List<TaskEntity> displayTasks = const [],
      this.skip = 0,
      this.limit = 10,
      this.total = 0,
      this.hasReachedMax = false,
      this.searchQuery = '',
      this.filter = 'all',
      this.sortBy = 'created_at',
      this.sortAscending = false,
      this.errorMessage})
      : _tasks = tasks,
        _displayTasks = displayTasks;

  @override
  @JsonKey()
  final TaskStatus status;
  final List<TaskEntity> _tasks;
  @override
  @JsonKey()
  List<TaskEntity> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  final List<TaskEntity> _displayTasks;
  @override
  @JsonKey()
  List<TaskEntity> get displayTasks {
    if (_displayTasks is EqualUnmodifiableListView) return _displayTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_displayTasks);
  }

  @override
  @JsonKey()
  final int skip;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool hasReachedMax;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String filter;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool sortAscending;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TaskState(status: $status, tasks: $tasks, displayTasks: $displayTasks, skip: $skip, limit: $limit, total: $total, hasReachedMax: $hasReachedMax, searchQuery: $searchQuery, filter: $filter, sortBy: $sortBy, sortAscending: $sortAscending, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            const DeepCollectionEquality()
                .equals(other._displayTasks, _displayTasks) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_tasks),
      const DeepCollectionEquality().hash(_displayTasks),
      skip,
      limit,
      total,
      hasReachedMax,
      searchQuery,
      filter,
      sortBy,
      sortAscending,
      errorMessage);

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStateImplCopyWith<_$TaskStateImpl> get copyWith =>
      __$$TaskStateImplCopyWithImpl<_$TaskStateImpl>(this, _$identity);
}

abstract class _TaskState implements TaskState {
  const factory _TaskState(
      {final TaskStatus status,
      final List<TaskEntity> tasks,
      final List<TaskEntity> displayTasks,
      final int skip,
      final int limit,
      final int total,
      final bool hasReachedMax,
      final String searchQuery,
      final String filter,
      final String sortBy,
      final bool sortAscending,
      final String? errorMessage}) = _$TaskStateImpl;

  @override
  TaskStatus get status;
  @override
  List<TaskEntity> get tasks;
  @override
  List<TaskEntity> get displayTasks;
  @override
  int get skip;
  @override
  int get limit;
  @override
  int get total;
  @override
  bool get hasReachedMax;
  @override
  String get searchQuery;
  @override
  String get filter;
  @override
  String get sortBy;
  @override
  bool get sortAscending;
  @override
  String? get errorMessage;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskStateImplCopyWith<_$TaskStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
