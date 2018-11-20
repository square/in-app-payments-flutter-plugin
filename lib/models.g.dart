// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new
// ignore_for_file: test_types_in_equals

const GooglePayEnvironment _$prod = const GooglePayEnvironment._('prod');
const GooglePayEnvironment _$test = const GooglePayEnvironment._('test');

GooglePayEnvironment _$googlePayEnvironmentValueOf(String name) {
  switch (name) {
    case 'prod':
      return _$prod;
    case 'test':
      return _$test;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GooglePayEnvironment> _$googlePayEnvironmentValues =
    new BuiltSet<GooglePayEnvironment>(const <GooglePayEnvironment>[
  _$prod,
  _$test,
]);

const ErrorCode _$usageError = const ErrorCode._('usageError');
const ErrorCode _$noNetwork = const ErrorCode._('noNetwork');

ErrorCode _$errorCodeValueOf(String name) {
  switch (name) {
    case 'usageError':
      return _$usageError;
    case 'noNetwork':
      return _$noNetwork;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ErrorCode> _$errorCodeValues =
    new BuiltSet<ErrorCode>(const <ErrorCode>[
  _$usageError,
  _$noNetwork,
]);

const Brand _$otherBrand = const Brand._('otherBrand');
const Brand _$visa = const Brand._('visa');
const Brand _$mastercard = const Brand._('mastercard');
const Brand _$americanExpress = const Brand._('americanExpress');
const Brand _$discover = const Brand._('discover');
const Brand _$discoverDiners = const Brand._('discoverDiners');
const Brand _$jCB = const Brand._('jCB');
const Brand _$chinaUnionPay = const Brand._('chinaUnionPay');

Brand _$brandValueOf(String name) {
  switch (name) {
    case 'otherBrand':
      return _$otherBrand;
    case 'visa':
      return _$visa;
    case 'mastercard':
      return _$mastercard;
    case 'americanExpress':
      return _$americanExpress;
    case 'discover':
      return _$discover;
    case 'discoverDiners':
      return _$discoverDiners;
    case 'jCB':
      return _$jCB;
    case 'chinaUnionPay':
      return _$chinaUnionPay;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<Brand> _$brandValues = new BuiltSet<Brand>(const <Brand>[
  _$otherBrand,
  _$visa,
  _$mastercard,
  _$americanExpress,
  _$discover,
  _$discoverDiners,
  _$jCB,
  _$chinaUnionPay,
]);

const KeyboardAppearance _$dark = const KeyboardAppearance._('dark');
const KeyboardAppearance _$light = const KeyboardAppearance._('light');

KeyboardAppearance _$keyboardAppearanceValueOf(String name) {
  switch (name) {
    case 'dark':
      return _$dark;
    case 'light':
      return _$light;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<KeyboardAppearance> _$keyboardAppearanceValues =
    new BuiltSet<KeyboardAppearance>(const <KeyboardAppearance>[
  _$dark,
  _$light,
]);

Serializer<GooglePayEnvironment> _$googlePayEnvironmentSerializer =
    new _$GooglePayEnvironmentSerializer();
Serializer<ErrorCode> _$errorCodeSerializer = new _$ErrorCodeSerializer();
Serializer<Brand> _$brandSerializer = new _$BrandSerializer();
Serializer<CardDetails> _$cardDetailsSerializer = new _$CardDetailsSerializer();
Serializer<Card> _$cardSerializer = new _$CardSerializer();
Serializer<RGBAColor> _$rGBAColorSerializer = new _$RGBAColorSerializer();
Serializer<Font> _$fontSerializer = new _$FontSerializer();
Serializer<KeyboardAppearance> _$keyboardAppearanceSerializer =
    new _$KeyboardAppearanceSerializer();
Serializer<IOSTheme> _$iOSThemeSerializer = new _$IOSThemeSerializer();
Serializer<ErrorInfo> _$errorInfoSerializer = new _$ErrorInfoSerializer();

class _$GooglePayEnvironmentSerializer
    implements PrimitiveSerializer<GooglePayEnvironment> {
  static const Map<String, String> _toWire = const <String, String>{
    'prod': 'PROD',
    'test': 'TEST',
  };
  static const Map<String, String> _fromWire = const <String, String>{
    'PROD': 'prod',
    'TEST': 'test',
  };

  @override
  final Iterable<Type> types = const <Type>[GooglePayEnvironment];
  @override
  final String wireName = 'GooglePayEnvironment';

  @override
  Object serialize(Serializers serializers, GooglePayEnvironment object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GooglePayEnvironment deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GooglePayEnvironment.valueOf(
          _fromWire[serialized] ?? serialized as String);
}

class _$ErrorCodeSerializer implements PrimitiveSerializer<ErrorCode> {
  static const Map<String, String> _toWire = const <String, String>{
    'usageError': 'USAGE_ERROR',
    'noNetwork': 'NO_NETWORK',
  };
  static const Map<String, String> _fromWire = const <String, String>{
    'USAGE_ERROR': 'usageError',
    'NO_NETWORK': 'noNetwork',
  };

  @override
  final Iterable<Type> types = const <Type>[ErrorCode];
  @override
  final String wireName = 'ErrorCode';

  @override
  Object serialize(Serializers serializers, ErrorCode object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ErrorCode deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ErrorCode.valueOf(_fromWire[serialized] ?? serialized as String);
}

class _$BrandSerializer implements PrimitiveSerializer<Brand> {
  static const Map<String, String> _toWire = const <String, String>{
    'otherBrand': 'OTHER_BRAND',
    'visa': 'VISA',
    'mastercard': 'MASTERCARD',
    'americanExpress': 'AMERICAN_EXPRESS',
    'discover': 'DISCOVER',
    'discoverDiners': 'DISCOVER_DINERS',
    'jCB': 'JCB',
    'chinaUnionPay': 'CHINA_UNION_PAY',
  };
  static const Map<String, String> _fromWire = const <String, String>{
    'OTHER_BRAND': 'otherBrand',
    'VISA': 'visa',
    'MASTERCARD': 'mastercard',
    'AMERICAN_EXPRESS': 'americanExpress',
    'DISCOVER': 'discover',
    'DISCOVER_DINERS': 'discoverDiners',
    'JCB': 'jCB',
    'CHINA_UNION_PAY': 'chinaUnionPay',
  };

  @override
  final Iterable<Type> types = const <Type>[Brand];
  @override
  final String wireName = 'Brand';

  @override
  Object serialize(Serializers serializers, Brand object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  Brand deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Brand.valueOf(_fromWire[serialized] ?? serialized as String);
}

class _$CardDetailsSerializer implements StructuredSerializer<CardDetails> {
  @override
  final Iterable<Type> types = const [CardDetails, _$CardDetails];
  @override
  final String wireName = 'CardDetails';

  @override
  Iterable serialize(Serializers serializers, CardDetails object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'nonce',
      serializers.serialize(object.nonce,
          specifiedType: const FullType(String)),
      'card',
      serializers.serialize(object.card, specifiedType: const FullType(Card)),
    ];

    return result;
  }

  @override
  CardDetails deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CardDetailsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'nonce':
          result.nonce = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'card':
          result.card.replace(serializers.deserialize(value,
              specifiedType: const FullType(Card)) as Card);
          break;
      }
    }

    return result.build();
  }
}

class _$CardSerializer implements StructuredSerializer<Card> {
  @override
  final Iterable<Type> types = const [Card, _$Card];
  @override
  final String wireName = 'Card';

  @override
  Iterable serialize(Serializers serializers, Card object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'brand',
      serializers.serialize(object.brand, specifiedType: const FullType(Brand)),
      'lastFourDigits',
      serializers.serialize(object.lastFourDigits,
          specifiedType: const FullType(String)),
      'expirationMonth',
      serializers.serialize(object.expirationMonth,
          specifiedType: const FullType(int)),
      'expirationYear',
      serializers.serialize(object.expirationYear,
          specifiedType: const FullType(int)),
    ];
    if (object.postalCode != null) {
      result
        ..add('postalCode')
        ..add(serializers.serialize(object.postalCode,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Card deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CardBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'brand':
          result.brand = serializers.deserialize(value,
              specifiedType: const FullType(Brand)) as Brand;
          break;
        case 'lastFourDigits':
          result.lastFourDigits = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'expirationMonth':
          result.expirationMonth = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'expirationYear':
          result.expirationYear = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'postalCode':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$RGBAColorSerializer implements StructuredSerializer<RGBAColor> {
  @override
  final Iterable<Type> types = const [RGBAColor, _$RGBAColor];
  @override
  final String wireName = 'RGBAColor';

  @override
  Iterable serialize(Serializers serializers, RGBAColor object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'r',
      serializers.serialize(object.r, specifiedType: const FullType(int)),
      'g',
      serializers.serialize(object.g, specifiedType: const FullType(int)),
      'b',
      serializers.serialize(object.b, specifiedType: const FullType(int)),
    ];
    if (object.a != null) {
      result
        ..add('a')
        ..add(serializers.serialize(object.a,
            specifiedType: const FullType(double)));
    }

    return result;
  }

  @override
  RGBAColor deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RGBAColorBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'r':
          result.r = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'g':
          result.g = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'b':
          result.b = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'a':
          result.a = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$FontSerializer implements StructuredSerializer<Font> {
  @override
  final Iterable<Type> types = const [Font, _$Font];
  @override
  final String wireName = 'Font';

  @override
  Iterable serialize(Serializers serializers, Font object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(double)),
    ];
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Font deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FontBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$KeyboardAppearanceSerializer
    implements PrimitiveSerializer<KeyboardAppearance> {
  static const Map<String, String> _toWire = const <String, String>{
    'dark': 'Dark',
    'light': 'Light',
  };
  static const Map<String, String> _fromWire = const <String, String>{
    'Dark': 'dark',
    'Light': 'light',
  };

  @override
  final Iterable<Type> types = const <Type>[KeyboardAppearance];
  @override
  final String wireName = 'KeyboardAppearance';

  @override
  Object serialize(Serializers serializers, KeyboardAppearance object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  KeyboardAppearance deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      KeyboardAppearance.valueOf(_fromWire[serialized] ?? serialized as String);
}

class _$IOSThemeSerializer implements StructuredSerializer<IOSTheme> {
  @override
  final Iterable<Type> types = const [IOSTheme, _$IOSTheme];
  @override
  final String wireName = 'IOSTheme';

  @override
  Iterable serialize(Serializers serializers, IOSTheme object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.font != null) {
      result
        ..add('font')
        ..add(serializers.serialize(object.font,
            specifiedType: const FullType(Font)));
    }
    if (object.emphasisFont != null) {
      result
        ..add('emphasisFont')
        ..add(serializers.serialize(object.emphasisFont,
            specifiedType: const FullType(Font)));
    }
    if (object.backgroundColor != null) {
      result
        ..add('backgroundColor')
        ..add(serializers.serialize(object.backgroundColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.foregroundColor != null) {
      result
        ..add('foregroundColor')
        ..add(serializers.serialize(object.foregroundColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.textColor != null) {
      result
        ..add('textColor')
        ..add(serializers.serialize(object.textColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.placeholderTextColor != null) {
      result
        ..add('placeholderTextColor')
        ..add(serializers.serialize(object.placeholderTextColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.tintColor != null) {
      result
        ..add('tintColor')
        ..add(serializers.serialize(object.tintColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.messageColor != null) {
      result
        ..add('messageColor')
        ..add(serializers.serialize(object.messageColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.errorColor != null) {
      result
        ..add('errorColor')
        ..add(serializers.serialize(object.errorColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.saveButtonTitle != null) {
      result
        ..add('saveButtonTitle')
        ..add(serializers.serialize(object.saveButtonTitle,
            specifiedType: const FullType(String)));
    }
    if (object.saveButtonTextColor != null) {
      result
        ..add('saveButtonTextColor')
        ..add(serializers.serialize(object.saveButtonTextColor,
            specifiedType: const FullType(RGBAColor)));
    }
    if (object.keyboardAppearance != null) {
      result
        ..add('keyboardAppearance')
        ..add(serializers.serialize(object.keyboardAppearance,
            specifiedType: const FullType(KeyboardAppearance)));
    }

    return result;
  }

  @override
  IOSTheme deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new IOSThemeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'font':
          result.font.replace(serializers.deserialize(value,
              specifiedType: const FullType(Font)) as Font);
          break;
        case 'emphasisFont':
          result.emphasisFont.replace(serializers.deserialize(value,
              specifiedType: const FullType(Font)) as Font);
          break;
        case 'backgroundColor':
          result.backgroundColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'foregroundColor':
          result.foregroundColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'textColor':
          result.textColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'placeholderTextColor':
          result.placeholderTextColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'tintColor':
          result.tintColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'messageColor':
          result.messageColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'errorColor':
          result.errorColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'saveButtonTitle':
          result.saveButtonTitle = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'saveButtonTextColor':
          result.saveButtonTextColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor)) as RGBAColor);
          break;
        case 'keyboardAppearance':
          result.keyboardAppearance = serializers.deserialize(value,
                  specifiedType: const FullType(KeyboardAppearance))
              as KeyboardAppearance;
          break;
      }
    }

    return result.build();
  }
}

class _$ErrorInfoSerializer implements StructuredSerializer<ErrorInfo> {
  @override
  final Iterable<Type> types = const [ErrorInfo, _$ErrorInfo];
  @override
  final String wireName = 'ErrorInfo';

  @override
  Iterable serialize(Serializers serializers, ErrorInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'code',
      serializers.serialize(object.code,
          specifiedType: const FullType(ErrorCode)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'debugCode',
      serializers.serialize(object.debugCode,
          specifiedType: const FullType(String)),
      'debugMessage',
      serializers.serialize(object.debugMessage,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ErrorInfo deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ErrorInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'code':
          result.code = serializers.deserialize(value,
              specifiedType: const FullType(ErrorCode)) as ErrorCode;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'debugCode':
          result.debugCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'debugMessage':
          result.debugMessage = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$CardDetails extends CardDetails {
  @override
  final String nonce;
  @override
  final Card card;

  factory _$CardDetails([void updates(CardDetailsBuilder b)]) =>
      (new CardDetailsBuilder()..update(updates)).build();

  _$CardDetails._({this.nonce, this.card}) : super._() {
    if (nonce == null) {
      throw new BuiltValueNullFieldError('CardDetails', 'nonce');
    }
    if (card == null) {
      throw new BuiltValueNullFieldError('CardDetails', 'card');
    }
  }

  @override
  CardDetails rebuild(void updates(CardDetailsBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CardDetailsBuilder toBuilder() => new CardDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardDetails && nonce == other.nonce && card == other.card;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, nonce.hashCode), card.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CardDetails')
          ..add('nonce', nonce)
          ..add('card', card))
        .toString();
  }
}

class CardDetailsBuilder implements Builder<CardDetails, CardDetailsBuilder> {
  _$CardDetails _$v;

  String _nonce;
  String get nonce => _$this._nonce;
  set nonce(String nonce) => _$this._nonce = nonce;

  CardBuilder _card;
  CardBuilder get card => _$this._card ??= new CardBuilder();
  set card(CardBuilder card) => _$this._card = card;

  CardDetailsBuilder();

  CardDetailsBuilder get _$this {
    if (_$v != null) {
      _nonce = _$v.nonce;
      _card = _$v.card?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardDetails other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CardDetails;
  }

  @override
  void update(void updates(CardDetailsBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CardDetails build() {
    _$CardDetails _$result;
    try {
      _$result = _$v ?? new _$CardDetails._(nonce: nonce, card: card.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'card';
        card.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CardDetails', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Card extends Card {
  @override
  final Brand brand;
  @override
  final String lastFourDigits;
  @override
  final int expirationMonth;
  @override
  final int expirationYear;
  @override
  final String postalCode;

  factory _$Card([void updates(CardBuilder b)]) =>
      (new CardBuilder()..update(updates)).build();

  _$Card._(
      {this.brand,
      this.lastFourDigits,
      this.expirationMonth,
      this.expirationYear,
      this.postalCode})
      : super._() {
    if (brand == null) {
      throw new BuiltValueNullFieldError('Card', 'brand');
    }
    if (lastFourDigits == null) {
      throw new BuiltValueNullFieldError('Card', 'lastFourDigits');
    }
    if (expirationMonth == null) {
      throw new BuiltValueNullFieldError('Card', 'expirationMonth');
    }
    if (expirationYear == null) {
      throw new BuiltValueNullFieldError('Card', 'expirationYear');
    }
  }

  @override
  Card rebuild(void updates(CardBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CardBuilder toBuilder() => new CardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Card &&
        brand == other.brand &&
        lastFourDigits == other.lastFourDigits &&
        expirationMonth == other.expirationMonth &&
        expirationYear == other.expirationYear &&
        postalCode == other.postalCode;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, brand.hashCode), lastFourDigits.hashCode),
                expirationMonth.hashCode),
            expirationYear.hashCode),
        postalCode.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Card')
          ..add('brand', brand)
          ..add('lastFourDigits', lastFourDigits)
          ..add('expirationMonth', expirationMonth)
          ..add('expirationYear', expirationYear)
          ..add('postalCode', postalCode))
        .toString();
  }
}

class CardBuilder implements Builder<Card, CardBuilder> {
  _$Card _$v;

  Brand _brand;
  Brand get brand => _$this._brand;
  set brand(Brand brand) => _$this._brand = brand;

  String _lastFourDigits;
  String get lastFourDigits => _$this._lastFourDigits;
  set lastFourDigits(String lastFourDigits) =>
      _$this._lastFourDigits = lastFourDigits;

  int _expirationMonth;
  int get expirationMonth => _$this._expirationMonth;
  set expirationMonth(int expirationMonth) =>
      _$this._expirationMonth = expirationMonth;

  int _expirationYear;
  int get expirationYear => _$this._expirationYear;
  set expirationYear(int expirationYear) =>
      _$this._expirationYear = expirationYear;

  String _postalCode;
  String get postalCode => _$this._postalCode;
  set postalCode(String postalCode) => _$this._postalCode = postalCode;

  CardBuilder();

  CardBuilder get _$this {
    if (_$v != null) {
      _brand = _$v.brand;
      _lastFourDigits = _$v.lastFourDigits;
      _expirationMonth = _$v.expirationMonth;
      _expirationYear = _$v.expirationYear;
      _postalCode = _$v.postalCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Card other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Card;
  }

  @override
  void update(void updates(CardBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Card build() {
    final _$result = _$v ??
        new _$Card._(
            brand: brand,
            lastFourDigits: lastFourDigits,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            postalCode: postalCode);
    replace(_$result);
    return _$result;
  }
}

class _$RGBAColor extends RGBAColor {
  @override
  final int r;
  @override
  final int g;
  @override
  final int b;
  @override
  final double a;

  factory _$RGBAColor([void updates(RGBAColorBuilder b)]) =>
      (new RGBAColorBuilder()..update(updates)).build();

  _$RGBAColor._({this.r, this.g, this.b, this.a}) : super._() {
    if (r == null) {
      throw new BuiltValueNullFieldError('RGBAColor', 'r');
    }
    if (g == null) {
      throw new BuiltValueNullFieldError('RGBAColor', 'g');
    }
    if (b == null) {
      throw new BuiltValueNullFieldError('RGBAColor', 'b');
    }
  }

  @override
  RGBAColor rebuild(void updates(RGBAColorBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  RGBAColorBuilder toBuilder() => new RGBAColorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RGBAColor &&
        r == other.r &&
        g == other.g &&
        b == other.b &&
        a == other.a;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc($jc(0, r.hashCode), g.hashCode), b.hashCode), a.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RGBAColor')
          ..add('r', r)
          ..add('g', g)
          ..add('b', b)
          ..add('a', a))
        .toString();
  }
}

class RGBAColorBuilder implements Builder<RGBAColor, RGBAColorBuilder> {
  _$RGBAColor _$v;

  int _r;
  int get r => _$this._r;
  set r(int r) => _$this._r = r;

  int _g;
  int get g => _$this._g;
  set g(int g) => _$this._g = g;

  int _b;
  int get b => _$this._b;
  set b(int b) => _$this._b = b;

  double _a;
  double get a => _$this._a;
  set a(double a) => _$this._a = a;

  RGBAColorBuilder();

  RGBAColorBuilder get _$this {
    if (_$v != null) {
      _r = _$v.r;
      _g = _$v.g;
      _b = _$v.b;
      _a = _$v.a;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RGBAColor other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RGBAColor;
  }

  @override
  void update(void updates(RGBAColorBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$RGBAColor build() {
    final _$result = _$v ?? new _$RGBAColor._(r: r, g: g, b: b, a: a);
    replace(_$result);
    return _$result;
  }
}

class _$Font extends Font {
  @override
  final double size;
  @override
  final String name;

  factory _$Font([void updates(FontBuilder b)]) =>
      (new FontBuilder()..update(updates)).build();

  _$Font._({this.size, this.name}) : super._() {
    if (size == null) {
      throw new BuiltValueNullFieldError('Font', 'size');
    }
  }

  @override
  Font rebuild(void updates(FontBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  FontBuilder toBuilder() => new FontBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Font && size == other.size && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, size.hashCode), name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Font')
          ..add('size', size)
          ..add('name', name))
        .toString();
  }
}

class FontBuilder implements Builder<Font, FontBuilder> {
  _$Font _$v;

  double _size;
  double get size => _$this._size;
  set size(double size) => _$this._size = size;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  FontBuilder();

  FontBuilder get _$this {
    if (_$v != null) {
      _size = _$v.size;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Font other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Font;
  }

  @override
  void update(void updates(FontBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Font build() {
    final _$result = _$v ?? new _$Font._(size: size, name: name);
    replace(_$result);
    return _$result;
  }
}

class _$IOSTheme extends IOSTheme {
  @override
  final Font font;
  @override
  final Font emphasisFont;
  @override
  final RGBAColor backgroundColor;
  @override
  final RGBAColor foregroundColor;
  @override
  final RGBAColor textColor;
  @override
  final RGBAColor placeholderTextColor;
  @override
  final RGBAColor tintColor;
  @override
  final RGBAColor messageColor;
  @override
  final RGBAColor errorColor;
  @override
  final String saveButtonTitle;
  @override
  final RGBAColor saveButtonTextColor;
  @override
  final KeyboardAppearance keyboardAppearance;

  factory _$IOSTheme([void updates(IOSThemeBuilder b)]) =>
      (new IOSThemeBuilder()..update(updates)).build();

  _$IOSTheme._(
      {this.font,
      this.emphasisFont,
      this.backgroundColor,
      this.foregroundColor,
      this.textColor,
      this.placeholderTextColor,
      this.tintColor,
      this.messageColor,
      this.errorColor,
      this.saveButtonTitle,
      this.saveButtonTextColor,
      this.keyboardAppearance})
      : super._();

  @override
  IOSTheme rebuild(void updates(IOSThemeBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  IOSThemeBuilder toBuilder() => new IOSThemeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IOSTheme &&
        font == other.font &&
        emphasisFont == other.emphasisFont &&
        backgroundColor == other.backgroundColor &&
        foregroundColor == other.foregroundColor &&
        textColor == other.textColor &&
        placeholderTextColor == other.placeholderTextColor &&
        tintColor == other.tintColor &&
        messageColor == other.messageColor &&
        errorColor == other.errorColor &&
        saveButtonTitle == other.saveButtonTitle &&
        saveButtonTextColor == other.saveButtonTextColor &&
        keyboardAppearance == other.keyboardAppearance;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc($jc(0, font.hashCode),
                                                emphasisFont.hashCode),
                                            backgroundColor.hashCode),
                                        foregroundColor.hashCode),
                                    textColor.hashCode),
                                placeholderTextColor.hashCode),
                            tintColor.hashCode),
                        messageColor.hashCode),
                    errorColor.hashCode),
                saveButtonTitle.hashCode),
            saveButtonTextColor.hashCode),
        keyboardAppearance.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('IOSTheme')
          ..add('font', font)
          ..add('emphasisFont', emphasisFont)
          ..add('backgroundColor', backgroundColor)
          ..add('foregroundColor', foregroundColor)
          ..add('textColor', textColor)
          ..add('placeholderTextColor', placeholderTextColor)
          ..add('tintColor', tintColor)
          ..add('messageColor', messageColor)
          ..add('errorColor', errorColor)
          ..add('saveButtonTitle', saveButtonTitle)
          ..add('saveButtonTextColor', saveButtonTextColor)
          ..add('keyboardAppearance', keyboardAppearance))
        .toString();
  }
}

class IOSThemeBuilder implements Builder<IOSTheme, IOSThemeBuilder> {
  _$IOSTheme _$v;

  FontBuilder _font;
  FontBuilder get font => _$this._font ??= new FontBuilder();
  set font(FontBuilder font) => _$this._font = font;

  FontBuilder _emphasisFont;
  FontBuilder get emphasisFont => _$this._emphasisFont ??= new FontBuilder();
  set emphasisFont(FontBuilder emphasisFont) =>
      _$this._emphasisFont = emphasisFont;

  RGBAColorBuilder _backgroundColor;
  RGBAColorBuilder get backgroundColor =>
      _$this._backgroundColor ??= new RGBAColorBuilder();
  set backgroundColor(RGBAColorBuilder backgroundColor) =>
      _$this._backgroundColor = backgroundColor;

  RGBAColorBuilder _foregroundColor;
  RGBAColorBuilder get foregroundColor =>
      _$this._foregroundColor ??= new RGBAColorBuilder();
  set foregroundColor(RGBAColorBuilder foregroundColor) =>
      _$this._foregroundColor = foregroundColor;

  RGBAColorBuilder _textColor;
  RGBAColorBuilder get textColor =>
      _$this._textColor ??= new RGBAColorBuilder();
  set textColor(RGBAColorBuilder textColor) => _$this._textColor = textColor;

  RGBAColorBuilder _placeholderTextColor;
  RGBAColorBuilder get placeholderTextColor =>
      _$this._placeholderTextColor ??= new RGBAColorBuilder();
  set placeholderTextColor(RGBAColorBuilder placeholderTextColor) =>
      _$this._placeholderTextColor = placeholderTextColor;

  RGBAColorBuilder _tintColor;
  RGBAColorBuilder get tintColor =>
      _$this._tintColor ??= new RGBAColorBuilder();
  set tintColor(RGBAColorBuilder tintColor) => _$this._tintColor = tintColor;

  RGBAColorBuilder _messageColor;
  RGBAColorBuilder get messageColor =>
      _$this._messageColor ??= new RGBAColorBuilder();
  set messageColor(RGBAColorBuilder messageColor) =>
      _$this._messageColor = messageColor;

  RGBAColorBuilder _errorColor;
  RGBAColorBuilder get errorColor =>
      _$this._errorColor ??= new RGBAColorBuilder();
  set errorColor(RGBAColorBuilder errorColor) =>
      _$this._errorColor = errorColor;

  String _saveButtonTitle;
  String get saveButtonTitle => _$this._saveButtonTitle;
  set saveButtonTitle(String saveButtonTitle) =>
      _$this._saveButtonTitle = saveButtonTitle;

  RGBAColorBuilder _saveButtonTextColor;
  RGBAColorBuilder get saveButtonTextColor =>
      _$this._saveButtonTextColor ??= new RGBAColorBuilder();
  set saveButtonTextColor(RGBAColorBuilder saveButtonTextColor) =>
      _$this._saveButtonTextColor = saveButtonTextColor;

  KeyboardAppearance _keyboardAppearance;
  KeyboardAppearance get keyboardAppearance => _$this._keyboardAppearance;
  set keyboardAppearance(KeyboardAppearance keyboardAppearance) =>
      _$this._keyboardAppearance = keyboardAppearance;

  IOSThemeBuilder();

  IOSThemeBuilder get _$this {
    if (_$v != null) {
      _font = _$v.font?.toBuilder();
      _emphasisFont = _$v.emphasisFont?.toBuilder();
      _backgroundColor = _$v.backgroundColor?.toBuilder();
      _foregroundColor = _$v.foregroundColor?.toBuilder();
      _textColor = _$v.textColor?.toBuilder();
      _placeholderTextColor = _$v.placeholderTextColor?.toBuilder();
      _tintColor = _$v.tintColor?.toBuilder();
      _messageColor = _$v.messageColor?.toBuilder();
      _errorColor = _$v.errorColor?.toBuilder();
      _saveButtonTitle = _$v.saveButtonTitle;
      _saveButtonTextColor = _$v.saveButtonTextColor?.toBuilder();
      _keyboardAppearance = _$v.keyboardAppearance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IOSTheme other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$IOSTheme;
  }

  @override
  void update(void updates(IOSThemeBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$IOSTheme build() {
    _$IOSTheme _$result;
    try {
      _$result = _$v ??
          new _$IOSTheme._(
              font: _font?.build(),
              emphasisFont: _emphasisFont?.build(),
              backgroundColor: _backgroundColor?.build(),
              foregroundColor: _foregroundColor?.build(),
              textColor: _textColor?.build(),
              placeholderTextColor: _placeholderTextColor?.build(),
              tintColor: _tintColor?.build(),
              messageColor: _messageColor?.build(),
              errorColor: _errorColor?.build(),
              saveButtonTitle: saveButtonTitle,
              saveButtonTextColor: _saveButtonTextColor?.build(),
              keyboardAppearance: keyboardAppearance);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'font';
        _font?.build();
        _$failedField = 'emphasisFont';
        _emphasisFont?.build();
        _$failedField = 'backgroundColor';
        _backgroundColor?.build();
        _$failedField = 'foregroundColor';
        _foregroundColor?.build();
        _$failedField = 'textColor';
        _textColor?.build();
        _$failedField = 'placeholderTextColor';
        _placeholderTextColor?.build();
        _$failedField = 'tintColor';
        _tintColor?.build();
        _$failedField = 'messageColor';
        _messageColor?.build();
        _$failedField = 'errorColor';
        _errorColor?.build();

        _$failedField = 'saveButtonTextColor';
        _saveButtonTextColor?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'IOSTheme', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ErrorInfo extends ErrorInfo {
  @override
  final ErrorCode code;
  @override
  final String message;
  @override
  final String debugCode;
  @override
  final String debugMessage;

  factory _$ErrorInfo([void updates(ErrorInfoBuilder b)]) =>
      (new ErrorInfoBuilder()..update(updates)).build();

  _$ErrorInfo._({this.code, this.message, this.debugCode, this.debugMessage})
      : super._() {
    if (code == null) {
      throw new BuiltValueNullFieldError('ErrorInfo', 'code');
    }
    if (message == null) {
      throw new BuiltValueNullFieldError('ErrorInfo', 'message');
    }
    if (debugCode == null) {
      throw new BuiltValueNullFieldError('ErrorInfo', 'debugCode');
    }
    if (debugMessage == null) {
      throw new BuiltValueNullFieldError('ErrorInfo', 'debugMessage');
    }
  }

  @override
  ErrorInfo rebuild(void updates(ErrorInfoBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorInfoBuilder toBuilder() => new ErrorInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorInfo &&
        code == other.code &&
        message == other.message &&
        debugCode == other.debugCode &&
        debugMessage == other.debugMessage;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, code.hashCode), message.hashCode), debugCode.hashCode),
        debugMessage.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ErrorInfo')
          ..add('code', code)
          ..add('message', message)
          ..add('debugCode', debugCode)
          ..add('debugMessage', debugMessage))
        .toString();
  }
}

class ErrorInfoBuilder implements Builder<ErrorInfo, ErrorInfoBuilder> {
  _$ErrorInfo _$v;

  ErrorCode _code;
  ErrorCode get code => _$this._code;
  set code(ErrorCode code) => _$this._code = code;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  String _debugCode;
  String get debugCode => _$this._debugCode;
  set debugCode(String debugCode) => _$this._debugCode = debugCode;

  String _debugMessage;
  String get debugMessage => _$this._debugMessage;
  set debugMessage(String debugMessage) => _$this._debugMessage = debugMessage;

  ErrorInfoBuilder();

  ErrorInfoBuilder get _$this {
    if (_$v != null) {
      _code = _$v.code;
      _message = _$v.message;
      _debugCode = _$v.debugCode;
      _debugMessage = _$v.debugMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ErrorInfo;
  }

  @override
  void update(void updates(ErrorInfoBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ErrorInfo build() {
    final _$result = _$v ??
        new _$ErrorInfo._(
            code: code,
            message: message,
            debugCode: debugCode,
            debugMessage: debugMessage);
    replace(_$result);
    return _$result;
  }
}
