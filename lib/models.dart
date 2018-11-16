/*
Copyright 2018 Square Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'models.g.dart';

class GooglePayEnvironment extends EnumClass {
  static Serializer<GooglePayEnvironment> get serializer => _$googlePayEnvironmentSerializer;

  @BuiltValueEnumConst(wireName: 'PROD')
  static const GooglePayEnvironment prod = _$prod;
  @BuiltValueEnumConst(wireName: 'TEST')
  static const GooglePayEnvironment test = _$test;

  const GooglePayEnvironment._(String name) : super(name);

  static BuiltSet<GooglePayEnvironment> get values => _$googlePayEnvironmentValues;
  static GooglePayEnvironment valueOf(String name) => _$googlePayEnvironmentValueOf(name);
}

class ErrorCode extends EnumClass {
  static Serializer<ErrorCode> get serializer => _$errorCodeSerializer;

  @BuiltValueEnumConst(wireName: 'USAGE_ERROR')
  static const ErrorCode usageError = _$usageError;
  @BuiltValueEnumConst(wireName: 'NO_NETWORK')
  static const ErrorCode noNetwork = _$noNetwork;

  const ErrorCode._(String name) : super(name);

  static BuiltSet<ErrorCode> get values => _$errorCodeValues;
  static ErrorCode valueOf(String name) => _$errorCodeValueOf(name);
}

class Brand extends EnumClass {
  static Serializer<Brand> get serializer => _$brandSerializer;

  @BuiltValueEnumConst(wireName: 'OTHER_BRAND')
  static const Brand otherBrand = _$otherBrand;
  @BuiltValueEnumConst(wireName: 'VISA')
  static const Brand visa = _$visa;
  @BuiltValueEnumConst(wireName: 'MASTERCARD')
  static const Brand mastercard = _$mastercard;
  @BuiltValueEnumConst(wireName: 'AMERICAN_EXPRESS')
  static const Brand americanExpress = _$americanExpress;
  @BuiltValueEnumConst(wireName: 'DISCOVER')
  static const Brand discover = _$discover;
  @BuiltValueEnumConst(wireName: 'DISCOVER_DINERS')
  static const Brand discoverDiners = _$discoverDiners;
  @BuiltValueEnumConst(wireName: 'JCB')
  static const Brand jCB = _$jCB;
  @BuiltValueEnumConst(wireName: 'CHINA_UNION_PAY')
  static const Brand chinaUnionPay = _$chinaUnionPay;

  const Brand._(String name) : super(name);

  static BuiltSet<Brand> get values => _$brandValues;
  static Brand valueOf(String name) => _$brandValueOf(name);
}

abstract class CardDetails implements Built<CardDetails, CardDetailsBuilder> {
  String get nonce;
  Card get card;

  CardDetails._();
  factory CardDetails([updates(CardDetailsBuilder b)]) = _$CardDetails;
  static Serializer<CardDetails> get serializer => _$cardDetailsSerializer;
}

abstract class Card implements Built<Card, CardBuilder> {
  Brand get brand;
  String get lastFourDigits;
  int get expirationMonth;
  int get expirationYear;

  @nullable
  String get postalCode;

  Card._();
  factory Card([updates(CardBuilder b)]) = _$Card;
  static Serializer<Card> get serializer => _$cardSerializer;
}

abstract class RGBAColor implements Built<RGBAColor, RGBAColorBuilder> {
  int get r;
  int get g;
  int get b;
  
  @nullable
  double get a;

  RGBAColor._() {
    assert(r >= 0);
    assert(g >= 0);
    assert(b >= 0);
    assert(a == null || (a >= 0 && a <= 1.0));
  }
  factory RGBAColor([updates(RGBAColorBuilder b)]) = _$RGBAColor;
  static Serializer<RGBAColor> get serializer => _$rGBAColorSerializer;
}

abstract class Font implements Built<Font, FontBuilder> {
  double get size;

  @nullable
  String get name;

  Font._();
  factory Font([updates(FontBuilder b)]) = _$Font;
  static Serializer<Font> get serializer => _$fontSerializer;
}

class KeyboardAppearance extends EnumClass {
  static Serializer<KeyboardAppearance> get serializer => _$keyboardAppearanceSerializer;

  @BuiltValueEnumConst(wireName: 'Dark')
  static const KeyboardAppearance dark = _$dark;
  @BuiltValueEnumConst(wireName: 'Light')
  static const KeyboardAppearance light = _$light;

  const KeyboardAppearance._(String name) : super(name);

  static BuiltSet<KeyboardAppearance> get values => _$keyboardAppearanceValues;
  static KeyboardAppearance valueOf(String name) => _$keyboardAppearanceValueOf(name);
}

abstract class IOSTheme implements Built<IOSTheme, IOSThemeBuilder> {
  @nullable
  Font get font;
  @nullable
  Font get emphasisFont;
  @nullable
  RGBAColor get backgroundColor;
  @nullable
  RGBAColor get foregroundColor;
  @nullable
  RGBAColor get textColor;
  @nullable
  RGBAColor get placeholderTextColor;
  @nullable
  RGBAColor get tintColor;
  @nullable
  RGBAColor get messageColor;
  @nullable
  RGBAColor get errorColor;
  @nullable
  String get saveButtonTitle;
  @nullable
  RGBAColor get saveButtonTextColor;
  @nullable
  KeyboardAppearance get keyboardAppearance;

  IOSTheme._();
  factory IOSTheme([updates(IOSThemeBuilder b)]) = _$IOSTheme;
  static Serializer<IOSTheme> get serializer => _$iOSThemeSerializer;
}

abstract class ErrorInfo implements Built<ErrorInfo, ErrorInfoBuilder> {
  ErrorCode get code;
  String get message;
  String get debugCode;
  String get debugMessage;

  ErrorInfo._();
  factory ErrorInfo([updates(ErrorInfoBuilder b)]) = _$ErrorInfo;
  static Serializer<ErrorInfo> get serializer => _$errorInfoSerializer;
}