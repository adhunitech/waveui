// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'button_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ButtonTheme {

 ButtonTypeTheme get primaryButton; ButtonTypeTheme get secondaryButton; ButtonTypeTheme get destructiveButton; ButtonTypeTheme get outlineButton; ButtonTypeTheme get ghostButton;
/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ButtonThemeCopyWith<ButtonTheme> get copyWith => _$ButtonThemeCopyWithImpl<ButtonTheme>(this as ButtonTheme, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ButtonTheme&&(identical(other.primaryButton, primaryButton) || other.primaryButton == primaryButton)&&(identical(other.secondaryButton, secondaryButton) || other.secondaryButton == secondaryButton)&&(identical(other.destructiveButton, destructiveButton) || other.destructiveButton == destructiveButton)&&(identical(other.outlineButton, outlineButton) || other.outlineButton == outlineButton)&&(identical(other.ghostButton, ghostButton) || other.ghostButton == ghostButton));
}


@override
int get hashCode => Object.hash(runtimeType,primaryButton,secondaryButton,destructiveButton,outlineButton,ghostButton);



}

/// @nodoc
abstract mixin class $ButtonThemeCopyWith<$Res>  {
  factory $ButtonThemeCopyWith(ButtonTheme value, $Res Function(ButtonTheme) _then) = _$ButtonThemeCopyWithImpl;
@useResult
$Res call({
 ButtonTypeTheme primaryButton, ButtonTypeTheme secondaryButton, ButtonTypeTheme destructiveButton, ButtonTypeTheme outlineButton, ButtonTypeTheme ghostButton
});


$ButtonTypeThemeCopyWith<$Res> get primaryButton;$ButtonTypeThemeCopyWith<$Res> get secondaryButton;$ButtonTypeThemeCopyWith<$Res> get destructiveButton;$ButtonTypeThemeCopyWith<$Res> get outlineButton;$ButtonTypeThemeCopyWith<$Res> get ghostButton;

}
/// @nodoc
class _$ButtonThemeCopyWithImpl<$Res>
    implements $ButtonThemeCopyWith<$Res> {
  _$ButtonThemeCopyWithImpl(this._self, this._then);

  final ButtonTheme _self;
  final $Res Function(ButtonTheme) _then;

/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primaryButton = null,Object? secondaryButton = null,Object? destructiveButton = null,Object? outlineButton = null,Object? ghostButton = null,}) {
  return _then(_self.copyWith(
primaryButton: null == primaryButton ? _self.primaryButton : primaryButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,secondaryButton: null == secondaryButton ? _self.secondaryButton : secondaryButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,destructiveButton: null == destructiveButton ? _self.destructiveButton : destructiveButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,outlineButton: null == outlineButton ? _self.outlineButton : outlineButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,ghostButton: null == ghostButton ? _self.ghostButton : ghostButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,
  ));
}
/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get primaryButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.primaryButton, (value) {
    return _then(_self.copyWith(primaryButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get secondaryButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.secondaryButton, (value) {
    return _then(_self.copyWith(secondaryButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get destructiveButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.destructiveButton, (value) {
    return _then(_self.copyWith(destructiveButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get outlineButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.outlineButton, (value) {
    return _then(_self.copyWith(outlineButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get ghostButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.ghostButton, (value) {
    return _then(_self.copyWith(ghostButton: value));
  });
}
}


/// Adds pattern-matching-related methods to [ButtonTheme].
extension ButtonThemePatterns on ButtonTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ButtonTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ButtonTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ButtonTheme value)  $default,){
final _that = this;
switch (_that) {
case _ButtonTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ButtonTheme value)?  $default,){
final _that = this;
switch (_that) {
case _ButtonTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ButtonTypeTheme primaryButton,  ButtonTypeTheme secondaryButton,  ButtonTypeTheme destructiveButton,  ButtonTypeTheme outlineButton,  ButtonTypeTheme ghostButton)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ButtonTheme() when $default != null:
return $default(_that.primaryButton,_that.secondaryButton,_that.destructiveButton,_that.outlineButton,_that.ghostButton);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ButtonTypeTheme primaryButton,  ButtonTypeTheme secondaryButton,  ButtonTypeTheme destructiveButton,  ButtonTypeTheme outlineButton,  ButtonTypeTheme ghostButton)  $default,) {final _that = this;
switch (_that) {
case _ButtonTheme():
return $default(_that.primaryButton,_that.secondaryButton,_that.destructiveButton,_that.outlineButton,_that.ghostButton);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ButtonTypeTheme primaryButton,  ButtonTypeTheme secondaryButton,  ButtonTypeTheme destructiveButton,  ButtonTypeTheme outlineButton,  ButtonTypeTheme ghostButton)?  $default,) {final _that = this;
switch (_that) {
case _ButtonTheme() when $default != null:
return $default(_that.primaryButton,_that.secondaryButton,_that.destructiveButton,_that.outlineButton,_that.ghostButton);case _:
  return null;

}
}

}

/// @nodoc


class _ButtonTheme extends ButtonTheme {
  const _ButtonTheme({required this.primaryButton, required this.secondaryButton, required this.destructiveButton, required this.outlineButton, required this.ghostButton}): super._();
  

@override final  ButtonTypeTheme primaryButton;
@override final  ButtonTypeTheme secondaryButton;
@override final  ButtonTypeTheme destructiveButton;
@override final  ButtonTypeTheme outlineButton;
@override final  ButtonTypeTheme ghostButton;

/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ButtonThemeCopyWith<_ButtonTheme> get copyWith => __$ButtonThemeCopyWithImpl<_ButtonTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ButtonTheme&&(identical(other.primaryButton, primaryButton) || other.primaryButton == primaryButton)&&(identical(other.secondaryButton, secondaryButton) || other.secondaryButton == secondaryButton)&&(identical(other.destructiveButton, destructiveButton) || other.destructiveButton == destructiveButton)&&(identical(other.outlineButton, outlineButton) || other.outlineButton == outlineButton)&&(identical(other.ghostButton, ghostButton) || other.ghostButton == ghostButton));
}


@override
int get hashCode => Object.hash(runtimeType,primaryButton,secondaryButton,destructiveButton,outlineButton,ghostButton);



}

/// @nodoc
abstract mixin class _$ButtonThemeCopyWith<$Res> implements $ButtonThemeCopyWith<$Res> {
  factory _$ButtonThemeCopyWith(_ButtonTheme value, $Res Function(_ButtonTheme) _then) = __$ButtonThemeCopyWithImpl;
@override @useResult
$Res call({
 ButtonTypeTheme primaryButton, ButtonTypeTheme secondaryButton, ButtonTypeTheme destructiveButton, ButtonTypeTheme outlineButton, ButtonTypeTheme ghostButton
});


@override $ButtonTypeThemeCopyWith<$Res> get primaryButton;@override $ButtonTypeThemeCopyWith<$Res> get secondaryButton;@override $ButtonTypeThemeCopyWith<$Res> get destructiveButton;@override $ButtonTypeThemeCopyWith<$Res> get outlineButton;@override $ButtonTypeThemeCopyWith<$Res> get ghostButton;

}
/// @nodoc
class __$ButtonThemeCopyWithImpl<$Res>
    implements _$ButtonThemeCopyWith<$Res> {
  __$ButtonThemeCopyWithImpl(this._self, this._then);

  final _ButtonTheme _self;
  final $Res Function(_ButtonTheme) _then;

/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primaryButton = null,Object? secondaryButton = null,Object? destructiveButton = null,Object? outlineButton = null,Object? ghostButton = null,}) {
  return _then(_ButtonTheme(
primaryButton: null == primaryButton ? _self.primaryButton : primaryButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,secondaryButton: null == secondaryButton ? _self.secondaryButton : secondaryButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,destructiveButton: null == destructiveButton ? _self.destructiveButton : destructiveButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,outlineButton: null == outlineButton ? _self.outlineButton : outlineButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,ghostButton: null == ghostButton ? _self.ghostButton : ghostButton // ignore: cast_nullable_to_non_nullable
as ButtonTypeTheme,
  ));
}

/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get primaryButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.primaryButton, (value) {
    return _then(_self.copyWith(primaryButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get secondaryButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.secondaryButton, (value) {
    return _then(_self.copyWith(secondaryButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get destructiveButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.destructiveButton, (value) {
    return _then(_self.copyWith(destructiveButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get outlineButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.outlineButton, (value) {
    return _then(_self.copyWith(outlineButton: value));
  });
}/// Create a copy of ButtonTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ButtonTypeThemeCopyWith<$Res> get ghostButton {
  
  return $ButtonTypeThemeCopyWith<$Res>(_self.ghostButton, (value) {
    return _then(_self.copyWith(ghostButton: value));
  });
}
}

// dart format on
