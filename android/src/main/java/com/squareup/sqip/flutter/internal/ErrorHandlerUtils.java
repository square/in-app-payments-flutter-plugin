package com.squareup.sqip.flutter.internal;

import java.util.HashMap;
import java.util.Map;

final class ErrorHandlerUtils {
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

  public static Map<String, String> getCallbackErrorObject(String code, String message, String debugCode, String debugMessage) {
    Map<String, String> errorObject = new HashMap<>();
    errorObject.put("code", code);
    errorObject.put("message", message);
    errorObject.put("debugCode", debugCode);
    errorObject.put("debugMessage", debugMessage);
    return errorObject;
  }
}
