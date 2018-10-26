package com.squareup.mcomm.flutter.internal;

import java.util.HashMap;
import java.util.Map;

public final class ErrorHandlerUtils {
  public static final String USAGE_ERROR = "USAGE_ERROR";

  public static String getPluginErrorMessage(String pluginErrorCode) {
    return String.format("Something went wrong. Please contact the developer of this application and provide them with this error code: %s", pluginErrorCode);
  }

  public static Map<String, String> getDebugErrorObject(String debugCode, String debugMessage) {
    Map<String, String> errorData = new HashMap<>();
    errorData.put("debugCode", debugCode);
    errorData.put("debugMessage", debugMessage);
    return errorData;
  }
}
