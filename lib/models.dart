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

class ErrorCode extends EnumClass {
  static Serializer<ErrorCode> get serializer => _$errorCodeSerializer;

  @BuiltValueEnumConst(wireName: 'USAGE_ERROR')
  static const ErrorCode usageError = _$usageError;
  @BuiltValueEnumConst(wireName: 'NO_NETWORK')
  static const ErrorCode noNetwork = _$noNetwork;
  @BuiltValueEnumConst(wireName: 'FAILED')
  static const ErrorCode failed = _$failed;
  @BuiltValueEnumConst(wireName: 'CANCELED')
  static const ErrorCode canceled = _$canceled;
  @BuiltValueEnumConst(wireName: 'UNSUPPORTED_SDK_VERSION')
  static const ErrorCode unsupportedSDKVersion = _$unsupportedSDKVersion;
  @BuiltValueEnumConst(wireName: 'INCOMPLETE_FLOW')
  static const ErrorCode incompleteFlow = _$incompleteFlow;

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
  static const Brand jcb = _$jCB;
  @BuiltValueEnumConst(wireName: 'CHINA_UNION_PAY')
  static const Brand chinaUnionPay = _$chinaUnionPay;
  @BuiltValueEnumConst(wireName: 'SQUARE_GIFT_CARD')
  static const Brand squareGiftCard = _$squareGiftCard;

  const Brand._(String name) : super(name);

  static BuiltSet<Brand> get values => _$brandValues;
  static Brand valueOf(String name) => _$brandValueOf(name);
}

class CardType extends EnumClass {
  static Serializer<CardType> get serializer => _$cardTypeSerializer;

  @BuiltValueEnumConst(wireName: 'DEBIT')
  static const CardType debit = _$debit;
  @BuiltValueEnumConst(wireName: 'CREDIT')
  static const CardType credit = _$credit;
  @BuiltValueEnumConst(wireName: 'UNKNOWN')
  static const CardType unknown = _$unknownCardType;

  const CardType._(String name) : super(name);

  static BuiltSet<CardType> get values => _$cardTypeValues;
  static CardType valueOf(String name) => _$cardTypeValueOf(name);
}

class CardPrepaidType extends EnumClass {
  static Serializer<CardPrepaidType> get serializer =>
      _$cardPrepaidTypeSerializer;

  @BuiltValueEnumConst(wireName: 'PREPAID')
  static const CardPrepaidType prepaid = _$prepaid;
  @BuiltValueEnumConst(wireName: 'NOT_PREPAID')
  static const CardPrepaidType notPrepaid = _$notPrepaid;
  @BuiltValueEnumConst(wireName: 'UNKNOWN')
  static const CardPrepaidType unknown = _$unknownPrepaidType;

  const CardPrepaidType._(String name) : super(name);

  static BuiltSet<CardPrepaidType> get values => _$cardPrepaidTypeValues;
  static CardPrepaidType valueOf(String name) => _$cardPrepaidTypeValueOf(name);
}

class ApplePayPaymentType extends EnumClass {
  static Serializer<ApplePayPaymentType> get serializer =>
      _$applePayPaymentTypeSerializer;

  @BuiltValueEnumConst(wireName: 'FINAL')
  static const ApplePayPaymentType finalPayment = _$finalPayment;
  @BuiltValueEnumConst(wireName: 'PENDING')
  static const ApplePayPaymentType pendingPayment = _$pendingPayment;

  const ApplePayPaymentType._(String name) : super(name);

  static BuiltSet<ApplePayPaymentType> get values =>
      _$applePayPaymentTypeValues;
  static ApplePayPaymentType valueOf(String name) =>
      _$applePayPaymentTypeValueOf(name);
}

abstract class CardDetails implements Built<CardDetails, CardDetailsBuilder> {
  String get nonce;
  Card get card;

  CardDetails._();
  factory CardDetails([updates(CardDetailsBuilder b)?]) = _$CardDetails;
  static Serializer<CardDetails> get serializer => _$cardDetailsSerializer;
}

abstract class BuyerVerificationDetails
    implements
        Built<BuyerVerificationDetails, BuyerVerificationDetailsBuilder> {
  String get nonce;
  Card? get card;
  String get token;

  BuyerVerificationDetails._();
  factory BuyerVerificationDetails(
          [updates(BuyerVerificationDetailsBuilder b)/*!*/]) =
      _$BuyerVerificationDetails;
  static Serializer<BuyerVerificationDetails> get serializer =>
      _$buyerVerificationDetailsSerializer;
}

abstract class Card implements Built<Card, CardBuilder> {
  Brand get brand;
  String get lastFourDigits;
  int get expirationMonth;
  int get expirationYear;
  CardType get type;
  CardPrepaidType get prepaidType;

  String? get postalCode;

  Card._();
  factory Card([updates(CardBuilder b)/*!*/]) = _$Card;
  static Serializer<Card> get serializer => _$cardSerializer;
}

abstract class RGBAColor implements Built<RGBAColor, RGBAColorBuilder> {
  int get r;
  int get g;
  int get b;

  double? get a;

  RGBAColor._() {
    assert(r >= 0);
    assert(g >= 0);
    assert(b >= 0);
    assert(a == null || (a! >= 0 && a! <= 1.0));
  }
  factory RGBAColor([updates(RGBAColorBuilder b)/*!*/]) = _$RGBAColor;
  static Serializer<RGBAColor> get serializer => _$rGBAColorSerializer;
}

abstract class Font implements Built<Font, FontBuilder> {
  double get size;

  String? get name;

  Font._();
  factory Font([updates(FontBuilder b)/*!*/]) = _$Font;
  static Serializer<Font> get serializer => _$fontSerializer;
}

class KeyboardAppearance extends EnumClass {
  static Serializer<KeyboardAppearance> get serializer =>
      _$keyboardAppearanceSerializer;

  @BuiltValueEnumConst(wireName: 'Dark')
  static const KeyboardAppearance dark = _$dark;
  @BuiltValueEnumConst(wireName: 'Light')
  static const KeyboardAppearance light = _$light;

  const KeyboardAppearance._(String name) : super(name);

  static BuiltSet<KeyboardAppearance> get values => _$keyboardAppearanceValues;
  static KeyboardAppearance valueOf(String name) =>
      _$keyboardAppearanceValueOf(name);
}

abstract class IOSTheme implements Built<IOSTheme, IOSThemeBuilder> {
  Font? get font;
  RGBAColor? get backgroundColor;
  RGBAColor? get foregroundColor;
  RGBAColor? get textColor;
  RGBAColor? get placeholderTextColor;
  RGBAColor? get tintColor;
  RGBAColor? get messageColor;
  RGBAColor? get errorColor;
  String? get saveButtonTitle;
  Font? get saveButtonFont;
  RGBAColor? get saveButtonTextColor;
  KeyboardAppearance? get keyboardAppearance;

  IOSTheme._();
  factory IOSTheme([updates(IOSThemeBuilder b)?]) = _$IOSTheme;
  static Serializer<IOSTheme> get serializer => _$iOSThemeSerializer;
}

abstract class ErrorInfo implements Built<ErrorInfo, ErrorInfoBuilder> {
  ErrorCode get code;
  String get message;
  String get debugCode;
  String get debugMessage;

  ErrorInfo._();
  factory ErrorInfo([updates(ErrorInfoBuilder b)/*!*/]) = _$ErrorInfo;
  static Serializer<ErrorInfo> get serializer => _$errorInfoSerializer;
}

abstract class Money implements Built<Money, MoneyBuilder> {
  int get amount;
  String get currencyCode;

  Money._();
  factory Money([updates(MoneyBuilder b)/*!*/]) = _$Money;
  static Serializer<Money> get serializer => _$moneySerializer;
}

abstract class Contact implements Built<Contact, ContactBuilder> {
  String get givenName;
  String? get familyName;
  BuiltList<String>? get addressLines;
  String? get city;
  String? get countryCode;
  String? get email;
  String? get phone;
  String? get postalCode;
  String? get region;

  Contact._();
  factory Contact([updates(ContactBuilder b)/*!*/]) = _$Contact;
  static Serializer<Contact> get serializer => _$contactSerializer;
}
