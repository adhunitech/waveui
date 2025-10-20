// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextTheme {

 TextStyle get h1; TextStyle get h2; TextStyle get h3; TextStyle get h4; TextStyle get h5; TextStyle get h6; TextStyle get large; TextStyle get body; TextStyle get small;
/// Create a copy of TextTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextThemeCopyWith<TextTheme> get copyWith => _$TextThemeCopyWithImpl<TextTheme>(this as TextTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextTheme&&(identical(other.h1, h1) || other.h1 == h1)&&(identical(other.h2, h2) || other.h2 == h2)&&(identical(other.h3, h3) || other.h3 == h3)&&(identical(other.h4, h4) || other.h4 == h4)&&(identical(other.h5, h5) || other.h5 == h5)&&(identical(other.h6, h6) || other.h6 == h6)&&(identical(other.large, large) || other.large == large)&&(identical(other.body, body) || other.body == body)&&(identical(other.small, small) || other.small == small));
}


@override
int get hashCode => Object.hash(runtimeType,h1,h2,h3,h4,h5,h6,large,body,small);



}

/// @nodoc
abstract mixin class $TextThemeCopyWith<$Res>  {
  factory $TextThemeCopyWith(TextTheme value, $Res Function(TextTheme) _then) = _$TextThemeCopyWithImpl;
@useResult
$Res call({
 TextStyle h1, TextStyle h2, TextStyle h3, TextStyle h4, TextStyle h5, TextStyle h6, TextStyle large, TextStyle body, TextStyle small
});




}
/// @nodoc
class _$TextThemeCopyWithImpl<$Res>
    implements $TextThemeCopyWith<$Res> {
  _$TextThemeCopyWithImpl(this._self, this._then);

  final TextTheme _self;
  final $Res Function(TextTheme) _then;

/// Create a copy of TextTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? h1 = null,Object? h2 = null,Object? h3 = null,Object? h4 = null,Object? h5 = null,Object? h6 = null,Object? large = null,Object? body = null,Object? small = null,}) {
  return _then(_self.copyWith(
h1: null == h1 ? _self.h1 : h1 // ignore: cast_nullable_to_non_nullable
as TextStyle,h2: null == h2 ? _self.h2 : h2 // ignore: cast_nullable_to_non_nullable
as TextStyle,h3: null == h3 ? _self.h3 : h3 // ignore: cast_nullable_to_non_nullable
as TextStyle,h4: null == h4 ? _self.h4 : h4 // ignore: cast_nullable_to_non_nullable
as TextStyle,h5: null == h5 ? _self.h5 : h5 // ignore: cast_nullable_to_non_nullable
as TextStyle,h6: null == h6 ? _self.h6 : h6 // ignore: cast_nullable_to_non_nullable
as TextStyle,large: null == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as TextStyle,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as TextStyle,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as TextStyle,
  ));
}

}


/// Adds pattern-matching-related methods to [TextTheme].
extension TextThemePatterns on TextTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextTheme value)  $default,){
final _that = this;
switch (_that) {
case _TextTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextTheme value)?  $default,){
final _that = this;
switch (_that) {
case _TextTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TextStyle h1,  TextStyle h2,  TextStyle h3,  TextStyle h4,  TextStyle h5,  TextStyle h6,  TextStyle large,  TextStyle body,  TextStyle small)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextTheme() when $default != null:
return $default(_that.h1,_that.h2,_that.h3,_that.h4,_that.h5,_that.h6,_that.large,_that.body,_that.small);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TextStyle h1,  TextStyle h2,  TextStyle h3,  TextStyle h4,  TextStyle h5,  TextStyle h6,  TextStyle large,  TextStyle body,  TextStyle small)  $default,) {final _that = this;
switch (_that) {
case _TextTheme():
return $default(_that.h1,_that.h2,_that.h3,_that.h4,_that.h5,_that.h6,_that.large,_that.body,_that.small);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TextStyle h1,  TextStyle h2,  TextStyle h3,  TextStyle h4,  TextStyle h5,  TextStyle h6,  TextStyle large,  TextStyle body,  TextStyle small)?  $default,) {final _that = this;
switch (_that) {
case _TextTheme() when $default != null:
return $default(_that.h1,_that.h2,_that.h3,_that.h4,_that.h5,_that.h6,_that.large,_that.body,_that.small);case _:
  return null;

}
}

}

/// @nodoc


class _TextTheme extends TextTheme {
   _TextTheme({this.h1 = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 36, height: 1.2, fontWeight: FontWeight.w700), this.h2 = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 30, height: 1.2, fontWeight: FontWeight.w600), this.h3 = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 24, height: 1.3, fontWeight: FontWeight.w600), this.h4 = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 18, height: 1.4, fontWeight: FontWeight.w500), this.h5 = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 16, height: 1.4, fontWeight: FontWeight.w500), this.h6 = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 14, height: 1.4, fontWeight: FontWeight.w500), this.large = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 18, height: 1.4, fontWeight: FontWeight.w400), this.body = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 16, height: 1.5, fontWeight: FontWeight.w400), this.small = const TextStyle(fontFamily: 'Geist', package: 'waveui', fontSize: 14, height: 1.4, fontWeight: FontWeight.w400)}): super._();
  

@override@JsonKey() final  TextStyle h1;
@override@JsonKey() final  TextStyle h2;
@override@JsonKey() final  TextStyle h3;
@override@JsonKey() final  TextStyle h4;
@override@JsonKey() final  TextStyle h5;
@override@JsonKey() final  TextStyle h6;
@override@JsonKey() final  TextStyle large;
@override@JsonKey() final  TextStyle body;
@override@JsonKey() final  TextStyle small;

/// Create a copy of TextTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextThemeCopyWith<_TextTheme> get copyWith => __$TextThemeCopyWithImpl<_TextTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextTheme&&(identical(other.h1, h1) || other.h1 == h1)&&(identical(other.h2, h2) || other.h2 == h2)&&(identical(other.h3, h3) || other.h3 == h3)&&(identical(other.h4, h4) || other.h4 == h4)&&(identical(other.h5, h5) || other.h5 == h5)&&(identical(other.h6, h6) || other.h6 == h6)&&(identical(other.large, large) || other.large == large)&&(identical(other.body, body) || other.body == body)&&(identical(other.small, small) || other.small == small));
}


@override
int get hashCode => Object.hash(runtimeType,h1,h2,h3,h4,h5,h6,large,body,small);



}

/// @nodoc
abstract mixin class _$TextThemeCopyWith<$Res> implements $TextThemeCopyWith<$Res> {
  factory _$TextThemeCopyWith(_TextTheme value, $Res Function(_TextTheme) _then) = __$TextThemeCopyWithImpl;
@override @useResult
$Res call({
 TextStyle h1, TextStyle h2, TextStyle h3, TextStyle h4, TextStyle h5, TextStyle h6, TextStyle large, TextStyle body, TextStyle small
});




}
/// @nodoc
class __$TextThemeCopyWithImpl<$Res>
    implements _$TextThemeCopyWith<$Res> {
  __$TextThemeCopyWithImpl(this._self, this._then);

  final _TextTheme _self;
  final $Res Function(_TextTheme) _then;

/// Create a copy of TextTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? h1 = null,Object? h2 = null,Object? h3 = null,Object? h4 = null,Object? h5 = null,Object? h6 = null,Object? large = null,Object? body = null,Object? small = null,}) {
  return _then(_TextTheme(
h1: null == h1 ? _self.h1 : h1 // ignore: cast_nullable_to_non_nullable
as TextStyle,h2: null == h2 ? _self.h2 : h2 // ignore: cast_nullable_to_non_nullable
as TextStyle,h3: null == h3 ? _self.h3 : h3 // ignore: cast_nullable_to_non_nullable
as TextStyle,h4: null == h4 ? _self.h4 : h4 // ignore: cast_nullable_to_non_nullable
as TextStyle,h5: null == h5 ? _self.h5 : h5 // ignore: cast_nullable_to_non_nullable
as TextStyle,h6: null == h6 ? _self.h6 : h6 // ignore: cast_nullable_to_non_nullable
as TextStyle,large: null == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as TextStyle,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as TextStyle,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as TextStyle,
  ));
}


}

// dart format on
