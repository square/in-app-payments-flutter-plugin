package com.squareup.mcomm.flutter.internal.converter;

import com.squareup.mcomm.CardResult;
import java.util.HashMap;
import java.util.Map;

public final class CardResultConverter {

  private CardConverter cardConverter;

  public CardResultConverter(CardConverter cardConverter) {
    this.cardConverter = cardConverter;
  }

  public Map<String, Object> toMapObject(CardResult cardResult) {
    HashMap<String, Object> mapToReturn = new HashMap<>();
    mapToReturn.put("nonce", cardResult.getNonce());
    mapToReturn.put("card", cardConverter.toMapObject(cardResult.getCard()));

    return mapToReturn;
  }
}
