// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Theme {

 WaveAppBarTheme get appBarTheme; TextTheme get textTheme; ColorScheme get colorScheme; ButtonTheme get buttonTheme;
/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeCopyWith<Theme> get copyWith => _$ThemeCopyWithImpl<Theme>(this as Theme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Theme&&(identical(other.appBarTheme, appBarTheme) || other.appBarTheme == appBarTheme)&&(identical(other.textTheme, textTheme) || other.textTheme == textTheme)&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme)&&(identical(other.buttonTheme, buttonTheme) || other.buttonTheme == buttonTheme));
}


@override
int get hashCode => Object.hash(runtimeType,appBarTheme,textTheme,colorScheme,buttonTheme);



}

/// @nodoc
abstract mixin class $ThemeCopyWith<$Res>  {
  factory $ThemeCopyWith(Theme value, $Res Function(Theme) _then) = _$ThemeCopyWithImpl;
@useResult
$Res call({
 WaveAppBarTheme appBarTheme, TextTheme textTheme, ColorScheme colorScheme, ButtonTheme buttonTheme
});


$WaveAppBarThemeCopyWith<$Res> get appBarTheme;$TextThemeCopyWith<$Res> get textTheme;$ColorSchemeCopyWith<$Res> get colorScheme;$ButtonThemeCopyWith<$Res> get buttonTheme;

}
/// @nodoc
class _$ThemeCopyWithImpl<$Res>
    implements $ThemeCopyWith<$Res> {
  _$ThemeCopyWithImpl(this._self, this._then);

  final Theme _self;
  final $Res Function(Theme) _then;

/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appBarTheme = null,Object? textTheme = null,Object? colorScheme = null,Object? buttonTheme = null,}) {
  return _then(_self.copyWith(
appBarTheme: null == appBarTheme ? _self.appBarTheme : appBarTheme // ignore: cast_nullable_to_non_nullable
as WaveAppBarTheme,textTheme: null == textTheme ? _self.textTheme : textTheme // ignore: cast_nullable_to_non_nullable
as TextTheme,colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as ColorScheme,buttonTheme: null == buttonTheme ? _self.buttonTheme : buttonTheme // ignore: cast_nullable_to_non_nullable
as ButtonTheme,
  ));
}
/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaveAppBarThemeCopyWith<$Res> get appBarTheme {
  
  return $WaveAppBarThemeCopyWith<$Res>(_self.appBarTheme, (value) {
    return _then(_self.copyWith(appBarTheme: value));
  });
}/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextThemeCopyWith<$Res> get textTheme {
  
  return $TextThemeCopyWith<$Res>(_self.textTheme, (value) {
    return _then(_self.copyWith(textTheme: value));
  });
}/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ColorSchemeCopyWith<$Res> get colorScheme {
  
  return $ColorSchemeCopyWith<$Res>(_self.colorScheme, (value) {
    return _then(_self.copyWith(colorScheme: value));
  });
}/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonThemeCopyWith<$Res> get buttonTheme {
  
  return $ButtonThemeCopyWith<$Res>(_self.buttonTheme, (value) {
    return _then(_self.copyWith(buttonTheme: value));
  });
}
}


/// Adds pattern-matching-related methods to [Theme].
extension ThemePatterns on Theme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Theme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Theme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Theme value)  $default,){
final _that = this;
switch (_that) {
case _Theme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Theme value)?  $default,){
final _that = this;
switch (_that) {
case _Theme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WaveAppBarTheme appBarTheme,  TextTheme textTheme,  ColorScheme colorScheme,  ButtonTheme buttonTheme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Theme() when $default != null:
return $default(_that.appBarTheme,_that.textTheme,_that.colorScheme,_that.buttonTheme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WaveAppBarTheme appBarTheme,  TextTheme textTheme,  ColorScheme colorScheme,  ButtonTheme buttonTheme)  $default,) {final _that = this;
switch (_that) {
case _Theme():
return $default(_that.appBarTheme,_that.textTheme,_that.colorScheme,_that.buttonTheme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WaveAppBarTheme appBarTheme,  TextTheme textTheme,  ColorScheme colorScheme,  ButtonTheme buttonTheme)?  $default,) {final _that = this;
switch (_that) {
case _Theme() when $default != null:
return $default(_that.appBarTheme,_that.textTheme,_that.colorScheme,_that.buttonTheme);case _:
  return null;

}
}

}

/// @nodoc


class _Theme extends Theme {
  const _Theme({required this.appBarTheme, required this.textTheme, required this.colorScheme, required this.buttonTheme}): super._();
  

@override final  WaveAppBarTheme appBarTheme;
@override final  TextTheme textTheme;
@override final  ColorScheme colorScheme;
@override final  ButtonTheme buttonTheme;

/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemeCopyWith<_Theme> get copyWith => __$ThemeCopyWithImpl<_Theme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Theme&&(identical(other.appBarTheme, appBarTheme) || other.appBarTheme == appBarTheme)&&(identical(other.textTheme, textTheme) || other.textTheme == textTheme)&&(identical(other.colorScheme, colorScheme) || other.colorScheme == colorScheme)&&(identical(other.buttonTheme, buttonTheme) || other.buttonTheme == buttonTheme));
}


@override
int get hashCode => Object.hash(runtimeType,appBarTheme,textTheme,colorScheme,buttonTheme);



}

/// @nodoc
abstract mixin class _$ThemeCopyWith<$Res> implements $ThemeCopyWith<$Res> {
  factory _$ThemeCopyWith(_Theme value, $Res Function(_Theme) _then) = __$ThemeCopyWithImpl;
@override @useResult
$Res call({
 WaveAppBarTheme appBarTheme, TextTheme textTheme, ColorScheme colorScheme, ButtonTheme buttonTheme
});


@override $WaveAppBarThemeCopyWith<$Res> get appBarTheme;@override $TextThemeCopyWith<$Res> get textTheme;@override $ColorSchemeCopyWith<$Res> get colorScheme;@override $ButtonThemeCopyWith<$Res> get buttonTheme;

}
/// @nodoc
class __$ThemeCopyWithImpl<$Res>
    implements _$ThemeCopyWith<$Res> {
  __$ThemeCopyWithImpl(this._self, this._then);

  final _Theme _self;
  final $Res Function(_Theme) _then;

/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appBarTheme = null,Object? textTheme = null,Object? colorScheme = null,Object? buttonTheme = null,}) {
  return _then(_Theme(
appBarTheme: null == appBarTheme ? _self.appBarTheme : appBarTheme // ignore: cast_nullable_to_non_nullable
as WaveAppBarTheme,textTheme: null == textTheme ? _self.textTheme : textTheme // ignore: cast_nullable_to_non_nullable
as TextTheme,colorScheme: null == colorScheme ? _self.colorScheme : colorScheme // ignore: cast_nullable_to_non_nullable
as ColorScheme,buttonTheme: null == buttonTheme ? _self.buttonTheme : buttonTheme // ignore: cast_nullable_to_non_nullable
as ButtonTheme,
  ));
}

/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaveAppBarThemeCopyWith<$Res> get appBarTheme {
  
  return $WaveAppBarThemeCopyWith<$Res>(_self.appBarTheme, (value) {
    return _then(_self.copyWith(appBarTheme: value));
  });
}/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextThemeCopyWith<$Res> get textTheme {
  
  return $TextThemeCopyWith<$Res>(_self.textTheme, (value) {
    return _then(_self.copyWith(textTheme: value));
  });
}/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ColorSchemeCopyWith<$Res> get colorScheme {
  
  return $ColorSchemeCopyWith<$Res>(_self.colorScheme, (value) {
    return _then(_self.copyWith(colorScheme: value));
  });
}/// Create a copy of Theme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonThemeCopyWith<$Res> get buttonTheme {
  
  return $ButtonThemeCopyWith<$Res>(_self.buttonTheme, (value) {
    return _then(_self.copyWith(buttonTheme: value));
  });
}
}

// dart format on
