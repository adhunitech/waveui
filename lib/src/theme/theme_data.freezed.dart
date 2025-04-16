// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WaveThemeData {

 WaveColorScheme get colorScheme;
/// Create a copy of WaveThemeData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaveThemeDataCopyWith<WaveThemeData> get copyWith => _$WaveThemeDataCopyWithImpl<WaveThemeData>(this as WaveThemeData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaveThemeData&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme));
}


@override
int get hashCode => Object.hash(runtimeType,colorScheme);



}

/// @nodoc
abstract mixin class $WaveThemeDataCopyWith<$Res>  {
  factory $WaveThemeDataCopyWith(WaveThemeData value, $Res Function(WaveThemeData) _then) = _$WaveThemeDataCopyWithImpl;
@useResult
$Res call({
 WaveColorScheme colorScheme
});


$WaveColorSchemeCopyWith<$Res> get colorScheme;

}
/// @nodoc
class _$WaveThemeDataCopyWithImpl<$Res>
    implements $WaveThemeDataCopyWith<$Res> {
  _$WaveThemeDataCopyWithImpl(this._self, this._then);

  final WaveThemeData _self;
  final $Res Function(WaveThemeData) _then;

/// Create a copy of WaveThemeData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? colorScheme = null,}) {
  return _then(_self.copyWith(
colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as WaveColorScheme,
  ));
}
/// Create a copy of WaveThemeData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaveColorSchemeCopyWith<$Res> get colorScheme {
  
  return $WaveColorSchemeCopyWith<$Res>(_self.colorScheme, (value) {
    return _then(_self.copyWith(colorScheme: value));
  });
}
}


/// @nodoc


class _WaveThemeData extends WaveThemeData {
  const _WaveThemeData({required this.colorScheme}): super._();
  

@override final  WaveColorScheme colorScheme;

/// Create a copy of WaveThemeData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaveThemeDataCopyWith<_WaveThemeData> get copyWith => __$WaveThemeDataCopyWithImpl<_WaveThemeData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaveThemeData&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme));
}


@override
int get hashCode => Object.hash(runtimeType,colorScheme);



}

/// @nodoc
abstract mixin class _$WaveThemeDataCopyWith<$Res> implements $WaveThemeDataCopyWith<$Res> {
  factory _$WaveThemeDataCopyWith(_WaveThemeData value, $Res Function(_WaveThemeData) _then) = __$WaveThemeDataCopyWithImpl;
@override @useResult
$Res call({
 WaveColorScheme colorScheme
});


@override $WaveColorSchemeCopyWith<$Res> get colorScheme;

}
/// @nodoc
class __$WaveThemeDataCopyWithImpl<$Res>
    implements _$WaveThemeDataCopyWith<$Res> {
  __$WaveThemeDataCopyWithImpl(this._self, this._then);

  final _WaveThemeData _self;
  final $Res Function(_WaveThemeData) _then;

/// Create a copy of WaveThemeData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? colorScheme = null,}) {
  return _then(_WaveThemeData(
colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as WaveColorScheme,
  ));
}

/// Create a copy of WaveThemeData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaveColorSchemeCopyWith<$Res> get colorScheme {
  
  return $WaveColorSchemeCopyWith<$Res>(_self.colorScheme, (value) {
    return _then(_self.copyWith(colorScheme: value));
  });
}
}

// dart format on
