package com.squareup.sqip.flutter.internal.converter;

import com.squareup.sqip.CardDetails;
import java.util.HashMap;
import java.util.Map;

public final class CardDetailsConverter {

  private final CardConverter cardConverter;

  public CardDetailsConverter(CardConverter cardConverter) {
    this.cardConverter = cardConverter;
  }

  public Map<String, Object> toMapObject(CardDetails cardDetails) {
    HashMap<String, Object> mapToReturn = new HashMap<>();
    mapToReturn.put("nonce", cardDetails.getNonce());
    mapToReturn.put("card", cardConverter.toMapObject(cardDetails.getCard()));

    return mapToReturn;
  }
}
