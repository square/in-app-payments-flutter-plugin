package com.squareup.mcomm.flutter.internal.converter;

import com.squareup.mcomm.Card;
import java.util.HashMap;
import java.util.Map;

public final class CardConverter {
  private static final Map<Card.Brand, String> brandStringMap;

  static {
    brandStringMap = new HashMap<>();
    for (Card.Brand brand : Card.Brand.values()) {
      switch(brand) {
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
        case OTHER:
          brandStringMap.put(brand, "OTHER");
          break;
        default:
          throw new RuntimeException("Unexpected brand value: " + brand.name());
      }
    }
  }

  public Map<String, Object> toMapObject(Card card) {
    HashMap<String, Object> mapToReturn = new HashMap<>();
    mapToReturn.put("lastFourDigits", card.getLastFourDigits());
    mapToReturn.put("expirationMonth", card.getExpirationMonth());
    mapToReturn.put("expirationYear", card.getExpirationYear());
    mapToReturn.put("postalCode", card.getPostalCode());
    mapToReturn.put("brand", brandStringMap.get(card.getBrand()));

    return mapToReturn;
  }
}
