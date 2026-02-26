// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_last_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserLastMessageModel {

 String? get lastMessage; DateTime? get timestamp;
/// Create a copy of UserLastMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLastMessageModelCopyWith<UserLastMessageModel> get copyWith => _$UserLastMessageModelCopyWithImpl<UserLastMessageModel>(this as UserLastMessageModel, _$identity);

  /// Serializes this UserLastMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLastMessageModel&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastMessage,timestamp);

@override
String toString() {
  return 'UserLastMessageModel(lastMessage: $lastMessage, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $UserLastMessageModelCopyWith<$Res>  {
  factory $UserLastMessageModelCopyWith(UserLastMessageModel value, $Res Function(UserLastMessageModel) _then) = _$UserLastMessageModelCopyWithImpl;
@useResult
$Res call({
 String? lastMessage, DateTime? timestamp
});




}
/// @nodoc
class _$UserLastMessageModelCopyWithImpl<$Res>
    implements $UserLastMessageModelCopyWith<$Res> {
  _$UserLastMessageModelCopyWithImpl(this._self, this._then);

  final UserLastMessageModel _self;
  final $Res Function(UserLastMessageModel) _then;

/// Create a copy of UserLastMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastMessage = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserLastMessageModel].
extension UserLastMessageModelPatterns on UserLastMessageModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLastMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLastMessageModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLastMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _UserLastMessageModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLastMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserLastMessageModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? lastMessage,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLastMessageModel() when $default != null:
return $default(_that.lastMessage,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? lastMessage,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _UserLastMessageModel():
return $default(_that.lastMessage,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? lastMessage,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _UserLastMessageModel() when $default != null:
return $default(_that.lastMessage,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserLastMessageModel implements UserLastMessageModel {
  const _UserLastMessageModel({this.lastMessage, this.timestamp});
  factory _UserLastMessageModel.fromJson(Map<String, dynamic> json) => _$UserLastMessageModelFromJson(json);

@override final  String? lastMessage;
@override final  DateTime? timestamp;

/// Create a copy of UserLastMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLastMessageModelCopyWith<_UserLastMessageModel> get copyWith => __$UserLastMessageModelCopyWithImpl<_UserLastMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserLastMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLastMessageModel&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastMessage,timestamp);

@override
String toString() {
  return 'UserLastMessageModel(lastMessage: $lastMessage, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$UserLastMessageModelCopyWith<$Res> implements $UserLastMessageModelCopyWith<$Res> {
  factory _$UserLastMessageModelCopyWith(_UserLastMessageModel value, $Res Function(_UserLastMessageModel) _then) = __$UserLastMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String? lastMessage, DateTime? timestamp
});




}
/// @nodoc
class __$UserLastMessageModelCopyWithImpl<$Res>
    implements _$UserLastMessageModelCopyWith<$Res> {
  __$UserLastMessageModelCopyWithImpl(this._self, this._then);

  final _UserLastMessageModel _self;
  final $Res Function(_UserLastMessageModel) _then;

/// Create a copy of UserLastMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastMessage = freezed,Object? timestamp = freezed,}) {
  return _then(_UserLastMessageModel(
lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
