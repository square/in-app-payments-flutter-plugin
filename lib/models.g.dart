// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ErrorCode _$usageError = const ErrorCode._('usageError');
const ErrorCode _$noNetwork = const ErrorCode._('noNetwork');
const ErrorCode _$failed = const ErrorCode._('failed');
const ErrorCode _$canceled = const ErrorCode._('canceled');
const ErrorCode _$unsupportedSDKVersion =
    const ErrorCode._('unsupportedSDKVersion');
const ErrorCode _$incompleteFlow = const ErrorCode._('incompleteFlow');

ErrorCode _$errorCodeValueOf(String name) {
  switch (name) {
    case 'usageError':
      return _$usageError;
    case 'noNetwork':
      return _$noNetwork;
    case 'failed':
      return _$failed;
    case 'canceled':
      return _$canceled;
    case 'unsupportedSDKVersion':
      return _$unsupportedSDKVersion;
    case 'incompleteFlow':
      return _$incompleteFlow;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ErrorCode> _$errorCodeValues =
    new BuiltSet<ErrorCode>(const <ErrorCode>[
  _$usageError,
  _$noNetwork,
  _$failed,
  _$canceled,
  _$unsupportedSDKVersion,
  _$incompleteFlow,
]);

const Brand _$otherBrand = const Brand._('otherBrand');
const Brand _$visa = const Brand._('visa');
const Brand _$mastercard = const Brand._('mastercard');
const Brand _$americanExpress = const Brand._('americanExpress');
const Brand _$discover = const Brand._('discover');
const Brand _$discoverDiners = const Brand._('discoverDiners');
const Brand _$jCB = const Brand._('jcb');
const Brand _$chinaUnionPay = const Brand._('chinaUnionPay');
const Brand _$squareGiftCard = const Brand._('squareGiftCard');

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
    case 'jcb':
      return _$jCB;
    case 'chinaUnionPay':
      return _$chinaUnionPay;
    case 'squareGiftCard':
      return _$squareGiftCard;
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
  _$squareGiftCard,
]);

const CardType _$debit = const CardType._('debit');
const CardType _$credit = const CardType._('credit');
const CardType _$unknownCardType = const CardType._('unknown');

CardType _$cardTypeValueOf(String name) {
  switch (name) {
    case 'debit':
      return _$debit;
    case 'credit':
      return _$credit;
    case 'unknown':
      return _$unknownCardType;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CardType> _$cardTypeValues =
    new BuiltSet<CardType>(const <CardType>[
  _$debit,
  _$credit,
  _$unknownCardType,
]);

const CardPrepaidType _$prepaid = const CardPrepaidType._('prepaid');
const CardPrepaidType _$notPrepaid = const CardPrepaidType._('notPrepaid');
const CardPrepaidType _$unknownPrepaidType = const CardPrepaidType._('unknown');

CardPrepaidType _$cardPrepaidTypeValueOf(String name) {
  switch (name) {
    case 'prepaid':
      return _$prepaid;
    case 'notPrepaid':
      return _$notPrepaid;
    case 'unknown':
      return _$unknownPrepaidType;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CardPrepaidType> _$cardPrepaidTypeValues =
    new BuiltSet<CardPrepaidType>(const <CardPrepaidType>[
  _$prepaid,
  _$notPrepaid,
  _$unknownPrepaidType,
]);

const ApplePayPaymentType _$finalPayment =
    const ApplePayPaymentType._('finalPayment');
const ApplePayPaymentType _$pendingPayment =
    const ApplePayPaymentType._('pendingPayment');

ApplePayPaymentType _$applePayPaymentTypeValueOf(String name) {
  switch (name) {
    case 'finalPayment':
      return _$finalPayment;
    case 'pendingPayment':
      return _$pendingPayment;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ApplePayPaymentType> _$applePayPaymentTypeValues =
    new BuiltSet<ApplePayPaymentType>(const <ApplePayPaymentType>[
  _$finalPayment,
  _$pendingPayment,
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

Serializer<ErrorCode> _$errorCodeSerializer = new _$ErrorCodeSerializer();
Serializer<Brand> _$brandSerializer = new _$BrandSerializer();
Serializer<CardType> _$cardTypeSerializer = new _$CardTypeSerializer();
Serializer<CardPrepaidType> _$cardPrepaidTypeSerializer =
    new _$CardPrepaidTypeSerializer();
Serializer<ApplePayPaymentType> _$applePayPaymentTypeSerializer =
    new _$ApplePayPaymentTypeSerializer();
Serializer<CardDetails> _$cardDetailsSerializer = new _$CardDetailsSerializer();
Serializer<PaymentInfo> _$paymentInfoSerializer = new _$PaymentInfoSerializer();
Serializer<ShippingContact> _$shippingContactSerializer =
    new _$ShippingContactSerializer();
Serializer<ShippingPostalAddress> _$shippingPostalAddressSerializer =
    new _$ShippingPostalAddressSerializer();
Serializer<ShippingContactName> _$shippingContactNameSerializer =
    new _$ShippingContactNameSerializer();
Serializer<BuyerVerificationDetails> _$buyerVerificationDetailsSerializer =
    new _$BuyerVerificationDetailsSerializer();
Serializer<Card> _$cardSerializer = new _$CardSerializer();
Serializer<RGBAColor> _$rGBAColorSerializer = new _$RGBAColorSerializer();
Serializer<Font> _$fontSerializer = new _$FontSerializer();
Serializer<KeyboardAppearance> _$keyboardAppearanceSerializer =
    new _$KeyboardAppearanceSerializer();
Serializer<IOSTheme> _$iOSThemeSerializer = new _$IOSThemeSerializer();
Serializer<ErrorInfo> _$errorInfoSerializer = new _$ErrorInfoSerializer();
Serializer<Money> _$moneySerializer = new _$MoneySerializer();
Serializer<Contact> _$contactSerializer = new _$ContactSerializer();

class _$ErrorCodeSerializer implements PrimitiveSerializer<ErrorCode> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'usageError': 'USAGE_ERROR',
    'noNetwork': 'NO_NETWORK',
    'failed': 'FAILED',
    'canceled': 'CANCELED',
    'unsupportedSDKVersion': 'UNSUPPORTED_SDK_VERSION',
    'incompleteFlow': 'INCOMPLETE_FLOW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'USAGE_ERROR': 'usageError',
    'NO_NETWORK': 'noNetwork',
    'FAILED': 'failed',
    'CANCELED': 'canceled',
    'UNSUPPORTED_SDK_VERSION': 'unsupportedSDKVersion',
    'INCOMPLETE_FLOW': 'incompleteFlow',
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
      ErrorCode.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BrandSerializer implements PrimitiveSerializer<Brand> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'otherBrand': 'OTHER_BRAND',
    'visa': 'VISA',
    'mastercard': 'MASTERCARD',
    'americanExpress': 'AMERICAN_EXPRESS',
    'discover': 'DISCOVER',
    'discoverDiners': 'DISCOVER_DINERS',
    'jcb': 'JCB',
    'chinaUnionPay': 'CHINA_UNION_PAY',
    'squareGiftCard': 'SQUARE_GIFT_CARD',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OTHER_BRAND': 'otherBrand',
    'VISA': 'visa',
    'MASTERCARD': 'mastercard',
    'AMERICAN_EXPRESS': 'americanExpress',
    'DISCOVER': 'discover',
    'DISCOVER_DINERS': 'discoverDiners',
    'JCB': 'jcb',
    'CHINA_UNION_PAY': 'chinaUnionPay',
    'SQUARE_GIFT_CARD': 'squareGiftCard',
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
      Brand.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CardTypeSerializer implements PrimitiveSerializer<CardType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'debit': 'DEBIT',
    'credit': 'CREDIT',
    'unknown': 'UNKNOWN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEBIT': 'debit',
    'CREDIT': 'credit',
    'UNKNOWN': 'unknown',
  };

  @override
  final Iterable<Type> types = const <Type>[CardType];
  @override
  final String wireName = 'CardType';

  @override
  Object serialize(Serializers serializers, CardType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CardType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CardType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CardPrepaidTypeSerializer
    implements PrimitiveSerializer<CardPrepaidType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'prepaid': 'PREPAID',
    'notPrepaid': 'NOT_PREPAID',
    'unknown': 'UNKNOWN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PREPAID': 'prepaid',
    'NOT_PREPAID': 'notPrepaid',
    'UNKNOWN': 'unknown',
  };

  @override
  final Iterable<Type> types = const <Type>[CardPrepaidType];
  @override
  final String wireName = 'CardPrepaidType';

  @override
  Object serialize(Serializers serializers, CardPrepaidType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CardPrepaidType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CardPrepaidType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApplePayPaymentTypeSerializer
    implements PrimitiveSerializer<ApplePayPaymentType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'finalPayment': 'FINAL',
    'pendingPayment': 'PENDING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FINAL': 'finalPayment',
    'PENDING': 'pendingPayment',
  };

  @override
  final Iterable<Type> types = const <Type>[ApplePayPaymentType];
  @override
  final String wireName = 'ApplePayPaymentType';

  @override
  Object serialize(Serializers serializers, ApplePayPaymentType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApplePayPaymentType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApplePayPaymentType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CardDetailsSerializer implements StructuredSerializer<CardDetails> {
  @override
  final Iterable<Type> types = const [CardDetails, _$CardDetails];
  @override
  final String wireName = 'CardDetails';

  @override
  Iterable<Object?> serialize(Serializers serializers, CardDetails object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'nonce',
      serializers.serialize(object.nonce,
          specifiedType: const FullType(String)),
      'card',
      serializers.serialize(object.card, specifiedType: const FullType(Card)),
    ];

    return result;
  }

  @override
  CardDetails deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CardDetailsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'nonce':
          result.nonce = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'card':
          result.card.replace(serializers.deserialize(value,
              specifiedType: const FullType(Card))! as Card);
          break;
      }
    }

    return result.build();
  }
}

class _$PaymentInfoSerializer implements StructuredSerializer<PaymentInfo> {
  @override
  final Iterable<Type> types = const [PaymentInfo, _$PaymentInfo];
  @override
  final String wireName = 'PaymentInfo';

  @override
  Iterable<Object?> serialize(Serializers serializers, PaymentInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'nonce',
      serializers.serialize(object.nonce,
          specifiedType: const FullType(String)),
      'card',
      serializers.serialize(object.card, specifiedType: const FullType(Card)),
    ];
    Object? value;
    value = object.shippingContact;
    if (value != null) {
      result
        ..add('shippingContact')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ShippingContact)));
    }
    return result;
  }

  @override
  PaymentInfo deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PaymentInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'nonce':
          result.nonce = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'card':
          result.card.replace(serializers.deserialize(value,
              specifiedType: const FullType(Card))! as Card);
          break;
        case 'shippingContact':
          result.shippingContact.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShippingContact))!
              as ShippingContact);
          break;
      }
    }

    return result.build();
  }
}

class _$ShippingContactSerializer
    implements StructuredSerializer<ShippingContact> {
  @override
  final Iterable<Type> types = const [ShippingContact, _$ShippingContact];
  @override
  final String wireName = 'ShippingContact';

  @override
  Iterable<Object?> serialize(Serializers serializers, ShippingContact object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'phoneNumber',
      serializers.serialize(object.phoneNumber,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'card',
      serializers.serialize(object.card, specifiedType: const FullType(Card)),
    ];
    Object? value;
    value = object.shippingAddress;
    if (value != null) {
      result
        ..add('shippingAddress')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ShippingPostalAddress)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(ShippingContactName)));
    }
    return result;
  }

  @override
  ShippingContact deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShippingContactBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'phoneNumber':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'card':
          result.card.replace(serializers.deserialize(value,
              specifiedType: const FullType(Card))! as Card);
          break;
        case 'shippingAddress':
          result.shippingAddress.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShippingPostalAddress))!
              as ShippingPostalAddress);
          break;
        case 'name':
          result.name.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShippingContactName))!
              as ShippingContactName);
          break;
      }
    }

    return result.build();
  }
}

class _$ShippingPostalAddressSerializer
    implements StructuredSerializer<ShippingPostalAddress> {
  @override
  final Iterable<Type> types = const [
    ShippingPostalAddress,
    _$ShippingPostalAddress
  ];
  @override
  final String wireName = 'ShippingPostalAddress';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ShippingPostalAddress object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'street',
      serializers.serialize(object.street,
          specifiedType: const FullType(String)),
      'city',
      serializers.serialize(object.city, specifiedType: const FullType(String)),
      'postalCode',
      serializers.serialize(object.postalCode,
          specifiedType: const FullType(String)),
      'country',
      serializers.serialize(object.country,
          specifiedType: const FullType(String)),
      'isoCountryCode',
      serializers.serialize(object.isoCountryCode,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ShippingPostalAddress deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShippingPostalAddressBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'street':
          result.street = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'postalCode':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'country':
          result.country = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'isoCountryCode':
          result.isoCountryCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ShippingContactNameSerializer
    implements StructuredSerializer<ShippingContactName> {
  @override
  final Iterable<Type> types = const [
    ShippingContactName,
    _$ShippingContactName
  ];
  @override
  final String wireName = 'ShippingContactName';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ShippingContactName object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.givenName;
    if (value != null) {
      result
        ..add('givenName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.middleName;
    if (value != null) {
      result
        ..add('middleName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.familyName;
    if (value != null) {
      result
        ..add('familyName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.nameSuffix;
    if (value != null) {
      result
        ..add('nameSuffix')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.nickname;
    if (value != null) {
      result
        ..add('nickname')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ShippingContactName deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShippingContactNameBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'givenName':
          result.givenName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'middleName':
          result.middleName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'familyName':
          result.familyName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'nameSuffix':
          result.nameSuffix = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'nickname':
          result.nickname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$BuyerVerificationDetailsSerializer
    implements StructuredSerializer<BuyerVerificationDetails> {
  @override
  final Iterable<Type> types = const [
    BuyerVerificationDetails,
    _$BuyerVerificationDetails
  ];
  @override
  final String wireName = 'BuyerVerificationDetails';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, BuyerVerificationDetails object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'nonce',
      serializers.serialize(object.nonce,
          specifiedType: const FullType(String)),
      'token',
      serializers.serialize(object.token,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.card;
    if (value != null) {
      result
        ..add('card')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(Card)));
    }
    return result;
  }

  @override
  BuyerVerificationDetails deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuyerVerificationDetailsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'nonce':
          result.nonce = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'card':
          result.card.replace(serializers.deserialize(value,
              specifiedType: const FullType(Card))! as Card);
          break;
        case 'token':
          result.token = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
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
  Iterable<Object?> serialize(Serializers serializers, Card object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
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
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(CardType)),
      'prepaidType',
      serializers.serialize(object.prepaidType,
          specifiedType: const FullType(CardPrepaidType)),
    ];
    Object? value;
    value = object.postalCode;
    if (value != null) {
      result
        ..add('postalCode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Card deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CardBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'brand':
          result.brand = serializers.deserialize(value,
              specifiedType: const FullType(Brand))! as Brand;
          break;
        case 'lastFourDigits':
          result.lastFourDigits = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'expirationMonth':
          result.expirationMonth = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'expirationYear':
          result.expirationYear = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(CardType))! as CardType;
          break;
        case 'prepaidType':
          result.prepaidType = serializers.deserialize(value,
                  specifiedType: const FullType(CardPrepaidType))!
              as CardPrepaidType;
          break;
        case 'postalCode':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
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
  Iterable<Object?> serialize(Serializers serializers, RGBAColor object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'r',
      serializers.serialize(object.r, specifiedType: const FullType(int)),
      'g',
      serializers.serialize(object.g, specifiedType: const FullType(int)),
      'b',
      serializers.serialize(object.b, specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.a;
    if (value != null) {
      result
        ..add('a')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  RGBAColor deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RGBAColorBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'r':
          result.r = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'g':
          result.g = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'b':
          result.b = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'a':
          result.a = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
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
  Iterable<Object?> serialize(Serializers serializers, Font object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(double)),
    ];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Font deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FontBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$KeyboardAppearanceSerializer
    implements PrimitiveSerializer<KeyboardAppearance> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'dark': 'Dark',
    'light': 'Light',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
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
      KeyboardAppearance.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$IOSThemeSerializer implements StructuredSerializer<IOSTheme> {
  @override
  final Iterable<Type> types = const [IOSTheme, _$IOSTheme];
  @override
  final String wireName = 'IOSTheme';

  @override
  Iterable<Object?> serialize(Serializers serializers, IOSTheme object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.font;
    if (value != null) {
      result
        ..add('font')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(Font)));
    }
    value = object.backgroundColor;
    if (value != null) {
      result
        ..add('backgroundColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.foregroundColor;
    if (value != null) {
      result
        ..add('foregroundColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.textColor;
    if (value != null) {
      result
        ..add('textColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.placeholderTextColor;
    if (value != null) {
      result
        ..add('placeholderTextColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.tintColor;
    if (value != null) {
      result
        ..add('tintColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.messageColor;
    if (value != null) {
      result
        ..add('messageColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.errorColor;
    if (value != null) {
      result
        ..add('errorColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.saveButtonTitle;
    if (value != null) {
      result
        ..add('saveButtonTitle')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.saveButtonFont;
    if (value != null) {
      result
        ..add('saveButtonFont')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(Font)));
    }
    value = object.saveButtonTextColor;
    if (value != null) {
      result
        ..add('saveButtonTextColor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(RGBAColor)));
    }
    value = object.keyboardAppearance;
    if (value != null) {
      result
        ..add('keyboardAppearance')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(KeyboardAppearance)));
    }
    return result;
  }

  @override
  IOSTheme deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new IOSThemeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'font':
          result.font.replace(serializers.deserialize(value,
              specifiedType: const FullType(Font))! as Font);
          break;
        case 'backgroundColor':
          result.backgroundColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'foregroundColor':
          result.foregroundColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'textColor':
          result.textColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'placeholderTextColor':
          result.placeholderTextColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'tintColor':
          result.tintColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'messageColor':
          result.messageColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'errorColor':
          result.errorColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'saveButtonTitle':
          result.saveButtonTitle = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'saveButtonFont':
          result.saveButtonFont.replace(serializers.deserialize(value,
              specifiedType: const FullType(Font))! as Font);
          break;
        case 'saveButtonTextColor':
          result.saveButtonTextColor.replace(serializers.deserialize(value,
              specifiedType: const FullType(RGBAColor))! as RGBAColor);
          break;
        case 'keyboardAppearance':
          result.keyboardAppearance = serializers.deserialize(value,
                  specifiedType: const FullType(KeyboardAppearance))
              as KeyboardAppearance?;
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
  Iterable<Object?> serialize(Serializers serializers, ErrorInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
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
  ErrorInfo deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ErrorInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'code':
          result.code = serializers.deserialize(value,
              specifiedType: const FullType(ErrorCode))! as ErrorCode;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'debugCode':
          result.debugCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'debugMessage':
          result.debugMessage = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MoneySerializer implements StructuredSerializer<Money> {
  @override
  final Iterable<Type> types = const [Money, _$Money];
  @override
  final String wireName = 'Money';

  @override
  Iterable<Object?> serialize(Serializers serializers, Money object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'amount',
      serializers.serialize(object.amount, specifiedType: const FullType(int)),
      'currencyCode',
      serializers.serialize(object.currencyCode,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Money deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MoneyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'currencyCode':
          result.currencyCode = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ContactSerializer implements StructuredSerializer<Contact> {
  @override
  final Iterable<Type> types = const [Contact, _$Contact];
  @override
  final String wireName = 'Contact';

  @override
  Iterable<Object?> serialize(Serializers serializers, Contact object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'givenName',
      serializers.serialize(object.givenName,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.familyName;
    if (value != null) {
      result
        ..add('familyName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.addressLines;
    if (value != null) {
      result
        ..add('addressLines')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.city;
    if (value != null) {
      result
        ..add('city')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.countryCode;
    if (value != null) {
      result
        ..add('countryCode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.phone;
    if (value != null) {
      result
        ..add('phone')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.postalCode;
    if (value != null) {
      result
        ..add('postalCode')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.region;
    if (value != null) {
      result
        ..add('region')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Contact deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ContactBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'givenName':
          result.givenName = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'familyName':
          result.familyName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'addressLines':
          result.addressLines.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'countryCode':
          result.countryCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'phone':
          result.phone = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'postalCode':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'region':
          result.region = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
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

  factory _$CardDetails([void Function(CardDetailsBuilder)? updates]) =>
      (new CardDetailsBuilder()..update(updates))._build();

  _$CardDetails._({required this.nonce, required this.card}) : super._() {
    BuiltValueNullFieldError.checkNotNull(nonce, r'CardDetails', 'nonce');
    BuiltValueNullFieldError.checkNotNull(card, r'CardDetails', 'card');
  }

  @override
  CardDetails rebuild(void Function(CardDetailsBuilder) updates) =>
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
    var _$hash = 0;
    _$hash = $jc(_$hash, nonce.hashCode);
    _$hash = $jc(_$hash, card.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CardDetails')
          ..add('nonce', nonce)
          ..add('card', card))
        .toString();
  }
}

class CardDetailsBuilder implements Builder<CardDetails, CardDetailsBuilder> {
  _$CardDetails? _$v;

  String? _nonce;
  String? get nonce => _$this._nonce;
  set nonce(String? nonce) => _$this._nonce = nonce;

  CardBuilder? _card;
  CardBuilder get card => _$this._card ??= new CardBuilder();
  set card(CardBuilder? card) => _$this._card = card;

  CardDetailsBuilder();

  CardDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nonce = $v.nonce;
      _card = $v.card.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardDetails other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CardDetails;
  }

  @override
  void update(void Function(CardDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CardDetails build() => _build();

  _$CardDetails _build() {
    _$CardDetails _$result;
    try {
      _$result = _$v ??
          new _$CardDetails._(
              nonce: BuiltValueNullFieldError.checkNotNull(
                  nonce, r'CardDetails', 'nonce'),
              card: card.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'card';
        card.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'CardDetails', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PaymentInfo extends PaymentInfo {
  @override
  final String nonce;
  @override
  final Card card;
  @override
  final ShippingContact? shippingContact;

  factory _$PaymentInfo([void Function(PaymentInfoBuilder)? updates]) =>
      (new PaymentInfoBuilder()..update(updates))._build();

  _$PaymentInfo._(
      {required this.nonce, required this.card, this.shippingContact})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(nonce, r'PaymentInfo', 'nonce');
    BuiltValueNullFieldError.checkNotNull(card, r'PaymentInfo', 'card');
  }

  @override
  PaymentInfo rebuild(void Function(PaymentInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentInfoBuilder toBuilder() => new PaymentInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentInfo &&
        nonce == other.nonce &&
        card == other.card &&
        shippingContact == other.shippingContact;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nonce.hashCode);
    _$hash = $jc(_$hash, card.hashCode);
    _$hash = $jc(_$hash, shippingContact.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentInfo')
          ..add('nonce', nonce)
          ..add('card', card)
          ..add('shippingContact', shippingContact))
        .toString();
  }
}

class PaymentInfoBuilder implements Builder<PaymentInfo, PaymentInfoBuilder> {
  _$PaymentInfo? _$v;

  String? _nonce;
  String? get nonce => _$this._nonce;
  set nonce(String? nonce) => _$this._nonce = nonce;

  CardBuilder? _card;
  CardBuilder get card => _$this._card ??= new CardBuilder();
  set card(CardBuilder? card) => _$this._card = card;

  ShippingContactBuilder? _shippingContact;
  ShippingContactBuilder get shippingContact =>
      _$this._shippingContact ??= new ShippingContactBuilder();
  set shippingContact(ShippingContactBuilder? shippingContact) =>
      _$this._shippingContact = shippingContact;

  PaymentInfoBuilder();

  PaymentInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nonce = $v.nonce;
      _card = $v.card.toBuilder();
      _shippingContact = $v.shippingContact?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PaymentInfo;
  }

  @override
  void update(void Function(PaymentInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentInfo build() => _build();

  _$PaymentInfo _build() {
    _$PaymentInfo _$result;
    try {
      _$result = _$v ??
          new _$PaymentInfo._(
              nonce: BuiltValueNullFieldError.checkNotNull(
                  nonce, r'PaymentInfo', 'nonce'),
              card: card.build(),
              shippingContact: _shippingContact?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'card';
        card.build();
        _$failedField = 'shippingContact';
        _shippingContact?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'PaymentInfo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ShippingContact extends ShippingContact {
  @override
  final String phoneNumber;
  @override
  final String email;
  @override
  final Card card;
  @override
  final ShippingPostalAddress? shippingAddress;
  @override
  final ShippingContactName? name;

  factory _$ShippingContact([void Function(ShippingContactBuilder)? updates]) =>
      (new ShippingContactBuilder()..update(updates))._build();

  _$ShippingContact._(
      {required this.phoneNumber,
      required this.email,
      required this.card,
      this.shippingAddress,
      this.name})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        phoneNumber, r'ShippingContact', 'phoneNumber');
    BuiltValueNullFieldError.checkNotNull(email, r'ShippingContact', 'email');
    BuiltValueNullFieldError.checkNotNull(card, r'ShippingContact', 'card');
  }

  @override
  ShippingContact rebuild(void Function(ShippingContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShippingContactBuilder toBuilder() =>
      new ShippingContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShippingContact &&
        phoneNumber == other.phoneNumber &&
        email == other.email &&
        card == other.card &&
        shippingAddress == other.shippingAddress &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, card.hashCode);
    _$hash = $jc(_$hash, shippingAddress.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShippingContact')
          ..add('phoneNumber', phoneNumber)
          ..add('email', email)
          ..add('card', card)
          ..add('shippingAddress', shippingAddress)
          ..add('name', name))
        .toString();
  }
}

class ShippingContactBuilder
    implements Builder<ShippingContact, ShippingContactBuilder> {
  _$ShippingContact? _$v;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  CardBuilder? _card;
  CardBuilder get card => _$this._card ??= new CardBuilder();
  set card(CardBuilder? card) => _$this._card = card;

  ShippingPostalAddressBuilder? _shippingAddress;
  ShippingPostalAddressBuilder get shippingAddress =>
      _$this._shippingAddress ??= new ShippingPostalAddressBuilder();
  set shippingAddress(ShippingPostalAddressBuilder? shippingAddress) =>
      _$this._shippingAddress = shippingAddress;

  ShippingContactNameBuilder? _name;
  ShippingContactNameBuilder get name =>
      _$this._name ??= new ShippingContactNameBuilder();
  set name(ShippingContactNameBuilder? name) => _$this._name = name;

  ShippingContactBuilder();

  ShippingContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phoneNumber = $v.phoneNumber;
      _email = $v.email;
      _card = $v.card.toBuilder();
      _shippingAddress = $v.shippingAddress?.toBuilder();
      _name = $v.name?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShippingContact other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShippingContact;
  }

  @override
  void update(void Function(ShippingContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShippingContact build() => _build();

  _$ShippingContact _build() {
    _$ShippingContact _$result;
    try {
      _$result = _$v ??
          new _$ShippingContact._(
              phoneNumber: BuiltValueNullFieldError.checkNotNull(
                  phoneNumber, r'ShippingContact', 'phoneNumber'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, r'ShippingContact', 'email'),
              card: card.build(),
              shippingAddress: _shippingAddress?.build(),
              name: _name?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'card';
        card.build();
        _$failedField = 'shippingAddress';
        _shippingAddress?.build();
        _$failedField = 'name';
        _name?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ShippingContact', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ShippingPostalAddress extends ShippingPostalAddress {
  @override
  final String street;
  @override
  final String city;
  @override
  final String postalCode;
  @override
  final String country;
  @override
  final String isoCountryCode;

  factory _$ShippingPostalAddress(
          [void Function(ShippingPostalAddressBuilder)? updates]) =>
      (new ShippingPostalAddressBuilder()..update(updates))._build();

  _$ShippingPostalAddress._(
      {required this.street,
      required this.city,
      required this.postalCode,
      required this.country,
      required this.isoCountryCode})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        street, r'ShippingPostalAddress', 'street');
    BuiltValueNullFieldError.checkNotNull(
        city, r'ShippingPostalAddress', 'city');
    BuiltValueNullFieldError.checkNotNull(
        postalCode, r'ShippingPostalAddress', 'postalCode');
    BuiltValueNullFieldError.checkNotNull(
        country, r'ShippingPostalAddress', 'country');
    BuiltValueNullFieldError.checkNotNull(
        isoCountryCode, r'ShippingPostalAddress', 'isoCountryCode');
  }

  @override
  ShippingPostalAddress rebuild(
          void Function(ShippingPostalAddressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShippingPostalAddressBuilder toBuilder() =>
      new ShippingPostalAddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShippingPostalAddress &&
        street == other.street &&
        city == other.city &&
        postalCode == other.postalCode &&
        country == other.country &&
        isoCountryCode == other.isoCountryCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, isoCountryCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShippingPostalAddress')
          ..add('street', street)
          ..add('city', city)
          ..add('postalCode', postalCode)
          ..add('country', country)
          ..add('isoCountryCode', isoCountryCode))
        .toString();
  }
}

class ShippingPostalAddressBuilder
    implements Builder<ShippingPostalAddress, ShippingPostalAddressBuilder> {
  _$ShippingPostalAddress? _$v;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _isoCountryCode;
  String? get isoCountryCode => _$this._isoCountryCode;
  set isoCountryCode(String? isoCountryCode) =>
      _$this._isoCountryCode = isoCountryCode;

  ShippingPostalAddressBuilder();

  ShippingPostalAddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _street = $v.street;
      _city = $v.city;
      _postalCode = $v.postalCode;
      _country = $v.country;
      _isoCountryCode = $v.isoCountryCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShippingPostalAddress other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShippingPostalAddress;
  }

  @override
  void update(void Function(ShippingPostalAddressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShippingPostalAddress build() => _build();

  _$ShippingPostalAddress _build() {
    final _$result = _$v ??
        new _$ShippingPostalAddress._(
            street: BuiltValueNullFieldError.checkNotNull(
                street, r'ShippingPostalAddress', 'street'),
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'ShippingPostalAddress', 'city'),
            postalCode: BuiltValueNullFieldError.checkNotNull(
                postalCode, r'ShippingPostalAddress', 'postalCode'),
            country: BuiltValueNullFieldError.checkNotNull(
                country, r'ShippingPostalAddress', 'country'),
            isoCountryCode: BuiltValueNullFieldError.checkNotNull(
                isoCountryCode, r'ShippingPostalAddress', 'isoCountryCode'));
    replace(_$result);
    return _$result;
  }
}

class _$ShippingContactName extends ShippingContactName {
  @override
  final String? givenName;
  @override
  final String? middleName;
  @override
  final String? familyName;
  @override
  final String? nameSuffix;
  @override
  final String? nickname;

  factory _$ShippingContactName(
          [void Function(ShippingContactNameBuilder)? updates]) =>
      (new ShippingContactNameBuilder()..update(updates))._build();

  _$ShippingContactName._(
      {this.givenName,
      this.middleName,
      this.familyName,
      this.nameSuffix,
      this.nickname})
      : super._();

  @override
  ShippingContactName rebuild(
          void Function(ShippingContactNameBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShippingContactNameBuilder toBuilder() =>
      new ShippingContactNameBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShippingContactName &&
        givenName == other.givenName &&
        middleName == other.middleName &&
        familyName == other.familyName &&
        nameSuffix == other.nameSuffix &&
        nickname == other.nickname;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, givenName.hashCode);
    _$hash = $jc(_$hash, middleName.hashCode);
    _$hash = $jc(_$hash, familyName.hashCode);
    _$hash = $jc(_$hash, nameSuffix.hashCode);
    _$hash = $jc(_$hash, nickname.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShippingContactName')
          ..add('givenName', givenName)
          ..add('middleName', middleName)
          ..add('familyName', familyName)
          ..add('nameSuffix', nameSuffix)
          ..add('nickname', nickname))
        .toString();
  }
}

class ShippingContactNameBuilder
    implements Builder<ShippingContactName, ShippingContactNameBuilder> {
  _$ShippingContactName? _$v;

  String? _givenName;
  String? get givenName => _$this._givenName;
  set givenName(String? givenName) => _$this._givenName = givenName;

  String? _middleName;
  String? get middleName => _$this._middleName;
  set middleName(String? middleName) => _$this._middleName = middleName;

  String? _familyName;
  String? get familyName => _$this._familyName;
  set familyName(String? familyName) => _$this._familyName = familyName;

  String? _nameSuffix;
  String? get nameSuffix => _$this._nameSuffix;
  set nameSuffix(String? nameSuffix) => _$this._nameSuffix = nameSuffix;

  String? _nickname;
  String? get nickname => _$this._nickname;
  set nickname(String? nickname) => _$this._nickname = nickname;

  ShippingContactNameBuilder();

  ShippingContactNameBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _givenName = $v.givenName;
      _middleName = $v.middleName;
      _familyName = $v.familyName;
      _nameSuffix = $v.nameSuffix;
      _nickname = $v.nickname;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShippingContactName other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShippingContactName;
  }

  @override
  void update(void Function(ShippingContactNameBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShippingContactName build() => _build();

  _$ShippingContactName _build() {
    final _$result = _$v ??
        new _$ShippingContactName._(
            givenName: givenName,
            middleName: middleName,
            familyName: familyName,
            nameSuffix: nameSuffix,
            nickname: nickname);
    replace(_$result);
    return _$result;
  }
}

class _$BuyerVerificationDetails extends BuyerVerificationDetails {
  @override
  final String nonce;
  @override
  final Card? card;
  @override
  final String token;

  factory _$BuyerVerificationDetails(
          [void Function(BuyerVerificationDetailsBuilder)? updates]) =>
      (new BuyerVerificationDetailsBuilder()..update(updates))._build();

  _$BuyerVerificationDetails._(
      {required this.nonce, this.card, required this.token})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        nonce, r'BuyerVerificationDetails', 'nonce');
    BuiltValueNullFieldError.checkNotNull(
        token, r'BuyerVerificationDetails', 'token');
  }

  @override
  BuyerVerificationDetails rebuild(
          void Function(BuyerVerificationDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerVerificationDetailsBuilder toBuilder() =>
      new BuyerVerificationDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerVerificationDetails &&
        nonce == other.nonce &&
        card == other.card &&
        token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nonce.hashCode);
    _$hash = $jc(_$hash, card.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerVerificationDetails')
          ..add('nonce', nonce)
          ..add('card', card)
          ..add('token', token))
        .toString();
  }
}

class BuyerVerificationDetailsBuilder
    implements
        Builder<BuyerVerificationDetails, BuyerVerificationDetailsBuilder> {
  _$BuyerVerificationDetails? _$v;

  String? _nonce;
  String? get nonce => _$this._nonce;
  set nonce(String? nonce) => _$this._nonce = nonce;

  CardBuilder? _card;
  CardBuilder get card => _$this._card ??= new CardBuilder();
  set card(CardBuilder? card) => _$this._card = card;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  BuyerVerificationDetailsBuilder();

  BuyerVerificationDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nonce = $v.nonce;
      _card = $v.card?.toBuilder();
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerVerificationDetails other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuyerVerificationDetails;
  }

  @override
  void update(void Function(BuyerVerificationDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerVerificationDetails build() => _build();

  _$BuyerVerificationDetails _build() {
    _$BuyerVerificationDetails _$result;
    try {
      _$result = _$v ??
          new _$BuyerVerificationDetails._(
              nonce: BuiltValueNullFieldError.checkNotNull(
                  nonce, r'BuyerVerificationDetails', 'nonce'),
              card: _card?.build(),
              token: BuiltValueNullFieldError.checkNotNull(
                  token, r'BuyerVerificationDetails', 'token'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'card';
        _card?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'BuyerVerificationDetails', _$failedField, e.toString());
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
  final CardType type;
  @override
  final CardPrepaidType prepaidType;
  @override
  final String? postalCode;

  factory _$Card([void Function(CardBuilder)? updates]) =>
      (new CardBuilder()..update(updates))._build();

  _$Card._(
      {required this.brand,
      required this.lastFourDigits,
      required this.expirationMonth,
      required this.expirationYear,
      required this.type,
      required this.prepaidType,
      this.postalCode})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(brand, r'Card', 'brand');
    BuiltValueNullFieldError.checkNotNull(
        lastFourDigits, r'Card', 'lastFourDigits');
    BuiltValueNullFieldError.checkNotNull(
        expirationMonth, r'Card', 'expirationMonth');
    BuiltValueNullFieldError.checkNotNull(
        expirationYear, r'Card', 'expirationYear');
    BuiltValueNullFieldError.checkNotNull(type, r'Card', 'type');
    BuiltValueNullFieldError.checkNotNull(prepaidType, r'Card', 'prepaidType');
  }

  @override
  Card rebuild(void Function(CardBuilder) updates) =>
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
        type == other.type &&
        prepaidType == other.prepaidType &&
        postalCode == other.postalCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, lastFourDigits.hashCode);
    _$hash = $jc(_$hash, expirationMonth.hashCode);
    _$hash = $jc(_$hash, expirationYear.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, prepaidType.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Card')
          ..add('brand', brand)
          ..add('lastFourDigits', lastFourDigits)
          ..add('expirationMonth', expirationMonth)
          ..add('expirationYear', expirationYear)
          ..add('type', type)
          ..add('prepaidType', prepaidType)
          ..add('postalCode', postalCode))
        .toString();
  }
}

class CardBuilder implements Builder<Card, CardBuilder> {
  _$Card? _$v;

  Brand? _brand;
  Brand? get brand => _$this._brand;
  set brand(Brand? brand) => _$this._brand = brand;

  String? _lastFourDigits;
  String? get lastFourDigits => _$this._lastFourDigits;
  set lastFourDigits(String? lastFourDigits) =>
      _$this._lastFourDigits = lastFourDigits;

  int? _expirationMonth;
  int? get expirationMonth => _$this._expirationMonth;
  set expirationMonth(int? expirationMonth) =>
      _$this._expirationMonth = expirationMonth;

  int? _expirationYear;
  int? get expirationYear => _$this._expirationYear;
  set expirationYear(int? expirationYear) =>
      _$this._expirationYear = expirationYear;

  CardType? _type;
  CardType? get type => _$this._type;
  set type(CardType? type) => _$this._type = type;

  CardPrepaidType? _prepaidType;
  CardPrepaidType? get prepaidType => _$this._prepaidType;
  set prepaidType(CardPrepaidType? prepaidType) =>
      _$this._prepaidType = prepaidType;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  CardBuilder();

  CardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brand = $v.brand;
      _lastFourDigits = $v.lastFourDigits;
      _expirationMonth = $v.expirationMonth;
      _expirationYear = $v.expirationYear;
      _type = $v.type;
      _prepaidType = $v.prepaidType;
      _postalCode = $v.postalCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Card other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Card;
  }

  @override
  void update(void Function(CardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Card build() => _build();

  _$Card _build() {
    final _$result = _$v ??
        new _$Card._(
            brand:
                BuiltValueNullFieldError.checkNotNull(brand, r'Card', 'brand'),
            lastFourDigits: BuiltValueNullFieldError.checkNotNull(
                lastFourDigits, r'Card', 'lastFourDigits'),
            expirationMonth: BuiltValueNullFieldError.checkNotNull(
                expirationMonth, r'Card', 'expirationMonth'),
            expirationYear: BuiltValueNullFieldError.checkNotNull(
                expirationYear, r'Card', 'expirationYear'),
            type: BuiltValueNullFieldError.checkNotNull(type, r'Card', 'type'),
            prepaidType: BuiltValueNullFieldError.checkNotNull(
                prepaidType, r'Card', 'prepaidType'),
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
  final double? a;

  factory _$RGBAColor([void Function(RGBAColorBuilder)? updates]) =>
      (new RGBAColorBuilder()..update(updates))._build();

  _$RGBAColor._({required this.r, required this.g, required this.b, this.a})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(r, r'RGBAColor', 'r');
    BuiltValueNullFieldError.checkNotNull(g, r'RGBAColor', 'g');
    BuiltValueNullFieldError.checkNotNull(b, r'RGBAColor', 'b');
  }

  @override
  RGBAColor rebuild(void Function(RGBAColorBuilder) updates) =>
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
    var _$hash = 0;
    _$hash = $jc(_$hash, r.hashCode);
    _$hash = $jc(_$hash, g.hashCode);
    _$hash = $jc(_$hash, b.hashCode);
    _$hash = $jc(_$hash, a.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RGBAColor')
          ..add('r', r)
          ..add('g', g)
          ..add('b', b)
          ..add('a', a))
        .toString();
  }
}

class RGBAColorBuilder implements Builder<RGBAColor, RGBAColorBuilder> {
  _$RGBAColor? _$v;

  int? _r;
  int? get r => _$this._r;
  set r(int? r) => _$this._r = r;

  int? _g;
  int? get g => _$this._g;
  set g(int? g) => _$this._g = g;

  int? _b;
  int? get b => _$this._b;
  set b(int? b) => _$this._b = b;

  double? _a;
  double? get a => _$this._a;
  set a(double? a) => _$this._a = a;

  RGBAColorBuilder();

  RGBAColorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _r = $v.r;
      _g = $v.g;
      _b = $v.b;
      _a = $v.a;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RGBAColor other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RGBAColor;
  }

  @override
  void update(void Function(RGBAColorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RGBAColor build() => _build();

  _$RGBAColor _build() {
    final _$result = _$v ??
        new _$RGBAColor._(
            r: BuiltValueNullFieldError.checkNotNull(r, r'RGBAColor', 'r'),
            g: BuiltValueNullFieldError.checkNotNull(g, r'RGBAColor', 'g'),
            b: BuiltValueNullFieldError.checkNotNull(b, r'RGBAColor', 'b'),
            a: a);
    replace(_$result);
    return _$result;
  }
}

class _$Font extends Font {
  @override
  final double size;
  @override
  final String? name;

  factory _$Font([void Function(FontBuilder)? updates]) =>
      (new FontBuilder()..update(updates))._build();

  _$Font._({required this.size, this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(size, r'Font', 'size');
  }

  @override
  Font rebuild(void Function(FontBuilder) updates) =>
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
    var _$hash = 0;
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Font')
          ..add('size', size)
          ..add('name', name))
        .toString();
  }
}

class FontBuilder implements Builder<Font, FontBuilder> {
  _$Font? _$v;

  double? _size;
  double? get size => _$this._size;
  set size(double? size) => _$this._size = size;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  FontBuilder();

  FontBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _size = $v.size;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Font other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Font;
  }

  @override
  void update(void Function(FontBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Font build() => _build();

  _$Font _build() {
    final _$result = _$v ??
        new _$Font._(
            size: BuiltValueNullFieldError.checkNotNull(size, r'Font', 'size'),
            name: name);
    replace(_$result);
    return _$result;
  }
}

class _$IOSTheme extends IOSTheme {
  @override
  final Font? font;
  @override
  final RGBAColor? backgroundColor;
  @override
  final RGBAColor? foregroundColor;
  @override
  final RGBAColor? textColor;
  @override
  final RGBAColor? placeholderTextColor;
  @override
  final RGBAColor? tintColor;
  @override
  final RGBAColor? messageColor;
  @override
  final RGBAColor? errorColor;
  @override
  final String? saveButtonTitle;
  @override
  final Font? saveButtonFont;
  @override
  final RGBAColor? saveButtonTextColor;
  @override
  final KeyboardAppearance? keyboardAppearance;

  factory _$IOSTheme([void Function(IOSThemeBuilder)? updates]) =>
      (new IOSThemeBuilder()..update(updates))._build();

  _$IOSTheme._(
      {this.font,
      this.backgroundColor,
      this.foregroundColor,
      this.textColor,
      this.placeholderTextColor,
      this.tintColor,
      this.messageColor,
      this.errorColor,
      this.saveButtonTitle,
      this.saveButtonFont,
      this.saveButtonTextColor,
      this.keyboardAppearance})
      : super._();

  @override
  IOSTheme rebuild(void Function(IOSThemeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IOSThemeBuilder toBuilder() => new IOSThemeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IOSTheme &&
        font == other.font &&
        backgroundColor == other.backgroundColor &&
        foregroundColor == other.foregroundColor &&
        textColor == other.textColor &&
        placeholderTextColor == other.placeholderTextColor &&
        tintColor == other.tintColor &&
        messageColor == other.messageColor &&
        errorColor == other.errorColor &&
        saveButtonTitle == other.saveButtonTitle &&
        saveButtonFont == other.saveButtonFont &&
        saveButtonTextColor == other.saveButtonTextColor &&
        keyboardAppearance == other.keyboardAppearance;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, font.hashCode);
    _$hash = $jc(_$hash, backgroundColor.hashCode);
    _$hash = $jc(_$hash, foregroundColor.hashCode);
    _$hash = $jc(_$hash, textColor.hashCode);
    _$hash = $jc(_$hash, placeholderTextColor.hashCode);
    _$hash = $jc(_$hash, tintColor.hashCode);
    _$hash = $jc(_$hash, messageColor.hashCode);
    _$hash = $jc(_$hash, errorColor.hashCode);
    _$hash = $jc(_$hash, saveButtonTitle.hashCode);
    _$hash = $jc(_$hash, saveButtonFont.hashCode);
    _$hash = $jc(_$hash, saveButtonTextColor.hashCode);
    _$hash = $jc(_$hash, keyboardAppearance.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IOSTheme')
          ..add('font', font)
          ..add('backgroundColor', backgroundColor)
          ..add('foregroundColor', foregroundColor)
          ..add('textColor', textColor)
          ..add('placeholderTextColor', placeholderTextColor)
          ..add('tintColor', tintColor)
          ..add('messageColor', messageColor)
          ..add('errorColor', errorColor)
          ..add('saveButtonTitle', saveButtonTitle)
          ..add('saveButtonFont', saveButtonFont)
          ..add('saveButtonTextColor', saveButtonTextColor)
          ..add('keyboardAppearance', keyboardAppearance))
        .toString();
  }
}

class IOSThemeBuilder implements Builder<IOSTheme, IOSThemeBuilder> {
  _$IOSTheme? _$v;

  FontBuilder? _font;
  FontBuilder get font => _$this._font ??= new FontBuilder();
  set font(FontBuilder? font) => _$this._font = font;

  RGBAColorBuilder? _backgroundColor;
  RGBAColorBuilder get backgroundColor =>
      _$this._backgroundColor ??= new RGBAColorBuilder();
  set backgroundColor(RGBAColorBuilder? backgroundColor) =>
      _$this._backgroundColor = backgroundColor;

  RGBAColorBuilder? _foregroundColor;
  RGBAColorBuilder get foregroundColor =>
      _$this._foregroundColor ??= new RGBAColorBuilder();
  set foregroundColor(RGBAColorBuilder? foregroundColor) =>
      _$this._foregroundColor = foregroundColor;

  RGBAColorBuilder? _textColor;
  RGBAColorBuilder get textColor =>
      _$this._textColor ??= new RGBAColorBuilder();
  set textColor(RGBAColorBuilder? textColor) => _$this._textColor = textColor;

  RGBAColorBuilder? _placeholderTextColor;
  RGBAColorBuilder get placeholderTextColor =>
      _$this._placeholderTextColor ??= new RGBAColorBuilder();
  set placeholderTextColor(RGBAColorBuilder? placeholderTextColor) =>
      _$this._placeholderTextColor = placeholderTextColor;

  RGBAColorBuilder? _tintColor;
  RGBAColorBuilder get tintColor =>
      _$this._tintColor ??= new RGBAColorBuilder();
  set tintColor(RGBAColorBuilder? tintColor) => _$this._tintColor = tintColor;

  RGBAColorBuilder? _messageColor;
  RGBAColorBuilder get messageColor =>
      _$this._messageColor ??= new RGBAColorBuilder();
  set messageColor(RGBAColorBuilder? messageColor) =>
      _$this._messageColor = messageColor;

  RGBAColorBuilder? _errorColor;
  RGBAColorBuilder get errorColor =>
      _$this._errorColor ??= new RGBAColorBuilder();
  set errorColor(RGBAColorBuilder? errorColor) =>
      _$this._errorColor = errorColor;

  String? _saveButtonTitle;
  String? get saveButtonTitle => _$this._saveButtonTitle;
  set saveButtonTitle(String? saveButtonTitle) =>
      _$this._saveButtonTitle = saveButtonTitle;

  FontBuilder? _saveButtonFont;
  FontBuilder get saveButtonFont =>
      _$this._saveButtonFont ??= new FontBuilder();
  set saveButtonFont(FontBuilder? saveButtonFont) =>
      _$this._saveButtonFont = saveButtonFont;

  RGBAColorBuilder? _saveButtonTextColor;
  RGBAColorBuilder get saveButtonTextColor =>
      _$this._saveButtonTextColor ??= new RGBAColorBuilder();
  set saveButtonTextColor(RGBAColorBuilder? saveButtonTextColor) =>
      _$this._saveButtonTextColor = saveButtonTextColor;

  KeyboardAppearance? _keyboardAppearance;
  KeyboardAppearance? get keyboardAppearance => _$this._keyboardAppearance;
  set keyboardAppearance(KeyboardAppearance? keyboardAppearance) =>
      _$this._keyboardAppearance = keyboardAppearance;

  IOSThemeBuilder();

  IOSThemeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _font = $v.font?.toBuilder();
      _backgroundColor = $v.backgroundColor?.toBuilder();
      _foregroundColor = $v.foregroundColor?.toBuilder();
      _textColor = $v.textColor?.toBuilder();
      _placeholderTextColor = $v.placeholderTextColor?.toBuilder();
      _tintColor = $v.tintColor?.toBuilder();
      _messageColor = $v.messageColor?.toBuilder();
      _errorColor = $v.errorColor?.toBuilder();
      _saveButtonTitle = $v.saveButtonTitle;
      _saveButtonFont = $v.saveButtonFont?.toBuilder();
      _saveButtonTextColor = $v.saveButtonTextColor?.toBuilder();
      _keyboardAppearance = $v.keyboardAppearance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IOSTheme other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$IOSTheme;
  }

  @override
  void update(void Function(IOSThemeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IOSTheme build() => _build();

  _$IOSTheme _build() {
    _$IOSTheme _$result;
    try {
      _$result = _$v ??
          new _$IOSTheme._(
              font: _font?.build(),
              backgroundColor: _backgroundColor?.build(),
              foregroundColor: _foregroundColor?.build(),
              textColor: _textColor?.build(),
              placeholderTextColor: _placeholderTextColor?.build(),
              tintColor: _tintColor?.build(),
              messageColor: _messageColor?.build(),
              errorColor: _errorColor?.build(),
              saveButtonTitle: saveButtonTitle,
              saveButtonFont: _saveButtonFont?.build(),
              saveButtonTextColor: _saveButtonTextColor?.build(),
              keyboardAppearance: keyboardAppearance);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'font';
        _font?.build();
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

        _$failedField = 'saveButtonFont';
        _saveButtonFont?.build();
        _$failedField = 'saveButtonTextColor';
        _saveButtonTextColor?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'IOSTheme', _$failedField, e.toString());
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

  factory _$ErrorInfo([void Function(ErrorInfoBuilder)? updates]) =>
      (new ErrorInfoBuilder()..update(updates))._build();

  _$ErrorInfo._(
      {required this.code,
      required this.message,
      required this.debugCode,
      required this.debugMessage})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(code, r'ErrorInfo', 'code');
    BuiltValueNullFieldError.checkNotNull(message, r'ErrorInfo', 'message');
    BuiltValueNullFieldError.checkNotNull(debugCode, r'ErrorInfo', 'debugCode');
    BuiltValueNullFieldError.checkNotNull(
        debugMessage, r'ErrorInfo', 'debugMessage');
  }

  @override
  ErrorInfo rebuild(void Function(ErrorInfoBuilder) updates) =>
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
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, debugCode.hashCode);
    _$hash = $jc(_$hash, debugMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorInfo')
          ..add('code', code)
          ..add('message', message)
          ..add('debugCode', debugCode)
          ..add('debugMessage', debugMessage))
        .toString();
  }
}

class ErrorInfoBuilder implements Builder<ErrorInfo, ErrorInfoBuilder> {
  _$ErrorInfo? _$v;

  ErrorCode? _code;
  ErrorCode? get code => _$this._code;
  set code(ErrorCode? code) => _$this._code = code;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _debugCode;
  String? get debugCode => _$this._debugCode;
  set debugCode(String? debugCode) => _$this._debugCode = debugCode;

  String? _debugMessage;
  String? get debugMessage => _$this._debugMessage;
  set debugMessage(String? debugMessage) => _$this._debugMessage = debugMessage;

  ErrorInfoBuilder();

  ErrorInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _message = $v.message;
      _debugCode = $v.debugCode;
      _debugMessage = $v.debugMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ErrorInfo;
  }

  @override
  void update(void Function(ErrorInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorInfo build() => _build();

  _$ErrorInfo _build() {
    final _$result = _$v ??
        new _$ErrorInfo._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ErrorInfo', 'code'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'ErrorInfo', 'message'),
            debugCode: BuiltValueNullFieldError.checkNotNull(
                debugCode, r'ErrorInfo', 'debugCode'),
            debugMessage: BuiltValueNullFieldError.checkNotNull(
                debugMessage, r'ErrorInfo', 'debugMessage'));
    replace(_$result);
    return _$result;
  }
}

class _$Money extends Money {
  @override
  final int amount;
  @override
  final String currencyCode;

  factory _$Money([void Function(MoneyBuilder)? updates]) =>
      (new MoneyBuilder()..update(updates))._build();

  _$Money._({required this.amount, required this.currencyCode}) : super._() {
    BuiltValueNullFieldError.checkNotNull(amount, r'Money', 'amount');
    BuiltValueNullFieldError.checkNotNull(
        currencyCode, r'Money', 'currencyCode');
  }

  @override
  Money rebuild(void Function(MoneyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MoneyBuilder toBuilder() => new MoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Money &&
        amount == other.amount &&
        currencyCode == other.currencyCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currencyCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Money')
          ..add('amount', amount)
          ..add('currencyCode', currencyCode))
        .toString();
  }
}

class MoneyBuilder implements Builder<Money, MoneyBuilder> {
  _$Money? _$v;

  int? _amount;
  int? get amount => _$this._amount;
  set amount(int? amount) => _$this._amount = amount;

  String? _currencyCode;
  String? get currencyCode => _$this._currencyCode;
  set currencyCode(String? currencyCode) => _$this._currencyCode = currencyCode;

  MoneyBuilder();

  MoneyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currencyCode = $v.currencyCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Money other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Money;
  }

  @override
  void update(void Function(MoneyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Money build() => _build();

  _$Money _build() {
    final _$result = _$v ??
        new _$Money._(
            amount: BuiltValueNullFieldError.checkNotNull(
                amount, r'Money', 'amount'),
            currencyCode: BuiltValueNullFieldError.checkNotNull(
                currencyCode, r'Money', 'currencyCode'));
    replace(_$result);
    return _$result;
  }
}

class _$Contact extends Contact {
  @override
  final String givenName;
  @override
  final String? familyName;
  @override
  final BuiltList<String>? addressLines;
  @override
  final String? city;
  @override
  final String? countryCode;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? postalCode;
  @override
  final String? region;

  factory _$Contact([void Function(ContactBuilder)? updates]) =>
      (new ContactBuilder()..update(updates))._build();

  _$Contact._(
      {required this.givenName,
      this.familyName,
      this.addressLines,
      this.city,
      this.countryCode,
      this.email,
      this.phone,
      this.postalCode,
      this.region})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(givenName, r'Contact', 'givenName');
  }

  @override
  Contact rebuild(void Function(ContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactBuilder toBuilder() => new ContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Contact &&
        givenName == other.givenName &&
        familyName == other.familyName &&
        addressLines == other.addressLines &&
        city == other.city &&
        countryCode == other.countryCode &&
        email == other.email &&
        phone == other.phone &&
        postalCode == other.postalCode &&
        region == other.region;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, givenName.hashCode);
    _$hash = $jc(_$hash, familyName.hashCode);
    _$hash = $jc(_$hash, addressLines.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, countryCode.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jc(_$hash, region.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Contact')
          ..add('givenName', givenName)
          ..add('familyName', familyName)
          ..add('addressLines', addressLines)
          ..add('city', city)
          ..add('countryCode', countryCode)
          ..add('email', email)
          ..add('phone', phone)
          ..add('postalCode', postalCode)
          ..add('region', region))
        .toString();
  }
}

class ContactBuilder implements Builder<Contact, ContactBuilder> {
  _$Contact? _$v;

  String? _givenName;
  String? get givenName => _$this._givenName;
  set givenName(String? givenName) => _$this._givenName = givenName;

  String? _familyName;
  String? get familyName => _$this._familyName;
  set familyName(String? familyName) => _$this._familyName = familyName;

  ListBuilder<String>? _addressLines;
  ListBuilder<String> get addressLines =>
      _$this._addressLines ??= new ListBuilder<String>();
  set addressLines(ListBuilder<String>? addressLines) =>
      _$this._addressLines = addressLines;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _countryCode;
  String? get countryCode => _$this._countryCode;
  set countryCode(String? countryCode) => _$this._countryCode = countryCode;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  String? _region;
  String? get region => _$this._region;
  set region(String? region) => _$this._region = region;

  ContactBuilder();

  ContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _givenName = $v.givenName;
      _familyName = $v.familyName;
      _addressLines = $v.addressLines?.toBuilder();
      _city = $v.city;
      _countryCode = $v.countryCode;
      _email = $v.email;
      _phone = $v.phone;
      _postalCode = $v.postalCode;
      _region = $v.region;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Contact other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Contact;
  }

  @override
  void update(void Function(ContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Contact build() => _build();

  _$Contact _build() {
    _$Contact _$result;
    try {
      _$result = _$v ??
          new _$Contact._(
              givenName: BuiltValueNullFieldError.checkNotNull(
                  givenName, r'Contact', 'givenName'),
              familyName: familyName,
              addressLines: _addressLines?.build(),
              city: city,
              countryCode: countryCode,
              email: email,
              phone: phone,
              postalCode: postalCode,
              region: region);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'addressLines';
        _addressLines?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Contact', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
