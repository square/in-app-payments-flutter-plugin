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
package com.squareup.sqip.flutter.internal.converter;

import com.squareup.sqip.CardDetails;
import java.util.LinkedHashMap;
import java.util.Map;

public final class CardDetailsConverter {

  private final CardConverter cardConverter;

  public CardDetailsConverter(CardConverter cardConverter) {
    this.cardConverter = cardConverter;
  }

  public Map<String, Object> toMapObject(CardDetails cardDetails) {
    Map<String, Object> mapToReturn = new LinkedHashMap<>();
    mapToReturn.put("nonce", cardDetails.getNonce());
    mapToReturn.put("card", cardConverter.toMapObject(cardDetails.getCard()));

    return mapToReturn;
  }
}
