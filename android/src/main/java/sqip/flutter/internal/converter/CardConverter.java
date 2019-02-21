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
package sqip.flutter.internal.converter;

import java.util.LinkedHashMap;
import java.util.Map;
import sqip.Card;

public final class CardConverter {
  private static final Map<Card.Brand, String> brandStringMap;
  private static final Map<Card.Type, String> typeStringMap;
  private static final Map<Card.PrepaidType, String> prepaidTypeStringMap;

  static {
    brandStringMap = new LinkedHashMap<>();
    for (Card.Brand brand : Card.Brand.values()) {
      switch(brand) {
        case OTHER_BRAND:
          brandStringMap.put(brand, "OTHER_BRAND");
          break;
        case VISA:
          brandStringMap.put(brand, "VISA");
          break;
        case MASTERCARD:
          brandStringMap.put(brand, "MASTERCARD");
          break;
        case AMERICAN_EXPRESS:
          brandStringMap.put(brand, "AMERICAN_EXPRESS");
          break;
        case DISCOVER:
          brandStringMap.put(brand, "DISCOVER");
          break;
        case DISCOVER_DINERS:
          brandStringMap.put(brand, "DISCOVER_DINERS");
          break;
        case JCB:
          brandStringMap.put(brand, "JCB");
          break;
        case CHINA_UNION_PAY:
          brandStringMap.put(brand, "CHINA_UNION_PAY");
          break;
        default:
          throw new RuntimeException("Unexpected brand value: " + brand.name());
      }
    }
    typeStringMap = new LinkedHashMap<>();
    for (Card.Type type : Card.Type.values()) {
      switch(type) {
        case DEBIT:
          typeStringMap.put(type, "DEBIT");
          break;
        case CREDIT:
          typeStringMap.put(type, "CREDIT");
          break;
        case UNKNOWN:
          typeStringMap.put(type, "UNKNOWN");
          break;
        default:
          throw new RuntimeException("Unexpected card type value: " + type.name());
      }
    }
    prepaidTypeStringMap = new LinkedHashMap<>();
    for (Card.PrepaidType prepaidType : Card.PrepaidType.values()) {
      switch(prepaidType) {
        case PREPAID:
          prepaidTypeStringMap.put(prepaidType, "PREPAID");
          break;
        case NOT_PREPAID:
          prepaidTypeStringMap.put(prepaidType, "NOT_PREPAID");
          break;
        case UNKNOWN:
          prepaidTypeStringMap.put(prepaidType, "UNKNOWN");
          break;
        default:
          throw new RuntimeException("Unexpected card prepaid type value: " + prepaidType.name());
      }
    }
  }

  public Map<String, Object> toMapObject(Card card) {
    Map<String, Object> mapToReturn = new LinkedHashMap<>();
    mapToReturn.put("brand", brandStringMap.get(card.getBrand()));
    mapToReturn.put("lastFourDigits", card.getLastFourDigits());
    mapToReturn.put("expirationMonth", card.getExpirationMonth());
    mapToReturn.put("expirationYear", card.getExpirationYear());
    mapToReturn.put("postalCode", card.getPostalCode());
    mapToReturn.put("type", typeStringMap.get(card.getType()));
    mapToReturn.put("prepaidType", prepaidTypeStringMap.get(card.getPrepaidType()));

    return mapToReturn;
  }
}
