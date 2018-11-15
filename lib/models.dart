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

  static const ErrorCode USAGE_ERROR = _$USAGE_ERROR;
  static const ErrorCode NO_NETWORK = _$NO_NETWORK;

  const ErrorCode._(String name) : super(name);

  static BuiltSet<ErrorCode> get values => _$errorCodeValues;
  static ErrorCode valueOf(String name) => _$errorCodeValueOf(name);
}

class Brand extends EnumClass {
  static Serializer<Brand> get serializer => _$brandSerializer;

  static const Brand OTHER_BRAND = _$OTHER_BRAND;
  static const Brand VISA = _$VISA;
  static const Brand MASTERCARD = _$MASTERCARD;
  static const Brand AMERICAN_EXPRESS = _$AMERICAN_EXPRESS;
  static const Brand DISCOVER = _$DISCOVER;
  static const Brand DISCOVER_DINERS = _$DISCOVER_DINERS;
  static const Brand JCB = _$JCB;
  static const Brand CHINA_UNION_PAY = _$CHINA_UNION_PAY;

  const Brand._(String name) : super(name);

  static BuiltSet<Brand> get values => _$values;
  static Brand valueOf(String name) => _$valueOf(name);
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

abstract class ErrorInfo implements Built<ErrorInfo, ErrorInfoBuilder> {
  ErrorCode get code;
  String get message;
  String get debugCode;
  String get debugMessage;

  ErrorInfo._();
  factory ErrorInfo([updates(ErrorInfoBuilder b)]) = _$ErrorInfo;
  static Serializer<ErrorInfo> get serializer => _$errorInfoSerializer;
}