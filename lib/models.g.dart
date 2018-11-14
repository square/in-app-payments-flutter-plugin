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

Serializer<CardDetails> _$cardDetailsSerializer = new _$CardDetailsSerializer();
Serializer<Card> _$cardSerializer = new _$CardSerializer();
Serializer<ErrorInfo> _$errorInfoSerializer = new _$ErrorInfoSerializer();

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
      serializers.serialize(object.brand,
          specifiedType: const FullType(String)),
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
              specifiedType: const FullType(String)) as String;
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
      serializers.serialize(object.code, specifiedType: const FullType(String)),
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
              specifiedType: const FullType(String)) as String;
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
  final String brand;
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

  String _brand;
  String get brand => _$this._brand;
  set brand(String brand) => _$this._brand = brand;

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

class _$ErrorInfo extends ErrorInfo {
  @override
  final String code;
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

  String _code;
  String get code => _$this._code;
  set code(String code) => _$this._code = code;

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
