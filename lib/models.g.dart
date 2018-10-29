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

Serializer<CardResult> _$cardResultSerializer = new _$CardResultSerializer();
Serializer<Card> _$cardSerializer = new _$CardSerializer();
Serializer<ErrorInfo> _$errorInfoSerializer = new _$ErrorInfoSerializer();

class _$CardResultSerializer implements StructuredSerializer<CardResult> {
  @override
  final Iterable<Type> types = const [CardResult, _$CardResult];
  @override
  final String wireName = 'CardResult';

  @override
  Iterable serialize(Serializers serializers, CardResult object,
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
  CardResult deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CardResultBuilder();

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
      'lastFourDigits',
      serializers.serialize(object.lastFourDigits,
          specifiedType: const FullType(String)),
      'expirationMonth',
      serializers.serialize(object.expirationMonth,
          specifiedType: const FullType(int)),
      'expirationYear',
      serializers.serialize(object.expirationYear,
          specifiedType: const FullType(int)),
      'postalCode',
      serializers.serialize(object.postalCode,
          specifiedType: const FullType(String)),
      'brand',
      serializers.serialize(object.brand,
          specifiedType: const FullType(String)),
    ];

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
        case 'brand':
          result.brand = serializers.deserialize(value,
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
      'message',
      serializers.serialize(object.message,
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
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$CardResult extends CardResult {
  @override
  final String nonce;
  @override
  final Card card;

  factory _$CardResult([void updates(CardResultBuilder b)]) =>
      (new CardResultBuilder()..update(updates)).build();

  _$CardResult._({this.nonce, this.card}) : super._() {
    if (nonce == null) {
      throw new BuiltValueNullFieldError('CardResult', 'nonce');
    }
    if (card == null) {
      throw new BuiltValueNullFieldError('CardResult', 'card');
    }
  }

  @override
  CardResult rebuild(void updates(CardResultBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CardResultBuilder toBuilder() => new CardResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardResult && nonce == other.nonce && card == other.card;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, nonce.hashCode), card.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CardResult')
          ..add('nonce', nonce)
          ..add('card', card))
        .toString();
  }
}

class CardResultBuilder implements Builder<CardResult, CardResultBuilder> {
  _$CardResult _$v;

  String _nonce;
  String get nonce => _$this._nonce;
  set nonce(String nonce) => _$this._nonce = nonce;

  CardBuilder _card;
  CardBuilder get card => _$this._card ??= new CardBuilder();
  set card(CardBuilder card) => _$this._card = card;

  CardResultBuilder();

  CardResultBuilder get _$this {
    if (_$v != null) {
      _nonce = _$v.nonce;
      _card = _$v.card?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardResult other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CardResult;
  }

  @override
  void update(void updates(CardResultBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CardResult build() {
    _$CardResult _$result;
    try {
      _$result = _$v ?? new _$CardResult._(nonce: nonce, card: card.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'card';
        card.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CardResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Card extends Card {
  @override
  final String lastFourDigits;
  @override
  final int expirationMonth;
  @override
  final int expirationYear;
  @override
  final String postalCode;
  @override
  final String brand;

  factory _$Card([void updates(CardBuilder b)]) =>
      (new CardBuilder()..update(updates)).build();

  _$Card._(
      {this.lastFourDigits,
      this.expirationMonth,
      this.expirationYear,
      this.postalCode,
      this.brand})
      : super._() {
    if (lastFourDigits == null) {
      throw new BuiltValueNullFieldError('Card', 'lastFourDigits');
    }
    if (expirationMonth == null) {
      throw new BuiltValueNullFieldError('Card', 'expirationMonth');
    }
    if (expirationYear == null) {
      throw new BuiltValueNullFieldError('Card', 'expirationYear');
    }
    if (postalCode == null) {
      throw new BuiltValueNullFieldError('Card', 'postalCode');
    }
    if (brand == null) {
      throw new BuiltValueNullFieldError('Card', 'brand');
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
        lastFourDigits == other.lastFourDigits &&
        expirationMonth == other.expirationMonth &&
        expirationYear == other.expirationYear &&
        postalCode == other.postalCode &&
        brand == other.brand;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, lastFourDigits.hashCode), expirationMonth.hashCode),
                expirationYear.hashCode),
            postalCode.hashCode),
        brand.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Card')
          ..add('lastFourDigits', lastFourDigits)
          ..add('expirationMonth', expirationMonth)
          ..add('expirationYear', expirationYear)
          ..add('postalCode', postalCode)
          ..add('brand', brand))
        .toString();
  }
}

class CardBuilder implements Builder<Card, CardBuilder> {
  _$Card _$v;

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

  String _brand;
  String get brand => _$this._brand;
  set brand(String brand) => _$this._brand = brand;

  CardBuilder();

  CardBuilder get _$this {
    if (_$v != null) {
      _lastFourDigits = _$v.lastFourDigits;
      _expirationMonth = _$v.expirationMonth;
      _expirationYear = _$v.expirationYear;
      _postalCode = _$v.postalCode;
      _brand = _$v.brand;
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
            lastFourDigits: lastFourDigits,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            postalCode: postalCode,
            brand: brand);
    replace(_$result);
    return _$result;
  }
}

class _$ErrorInfo extends ErrorInfo {
  @override
  final String message;

  factory _$ErrorInfo([void updates(ErrorInfoBuilder b)]) =>
      (new ErrorInfoBuilder()..update(updates)).build();

  _$ErrorInfo._({this.message}) : super._() {
    if (message == null) {
      throw new BuiltValueNullFieldError('ErrorInfo', 'message');
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
    return other is ErrorInfo && message == other.message;
  }

  @override
  int get hashCode {
    return $jf($jc(0, message.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ErrorInfo')..add('message', message))
        .toString();
  }
}

class ErrorInfoBuilder implements Builder<ErrorInfo, ErrorInfoBuilder> {
  _$ErrorInfo _$v;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  ErrorInfoBuilder();

  ErrorInfoBuilder get _$this {
    if (_$v != null) {
      _message = _$v.message;
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
    final _$result = _$v ?? new _$ErrorInfo._(message: message);
    replace(_$result);
    return _$result;
  }
}
