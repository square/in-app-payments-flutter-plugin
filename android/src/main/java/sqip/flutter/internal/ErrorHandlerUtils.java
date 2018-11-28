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
package sqip.flutter.internal;

import java.util.LinkedHashMap;
import java.util.Map;

final class ErrorHandlerUtils {
  public static final String USAGE_ERROR = "USAGE_ERROR";

  public static String getPluginErrorMessage(String pluginErrorCode) {
    return String.format("Something went wrong. Please contact the developer of this application and provide them with this error code: %s", pluginErrorCode);
  }

  public static Map<String, String> getDebugErrorObject(String debugCode, String debugMessage) {
    Map<String, String> errorData = new LinkedHashMap<>();
    errorData.put("debugCode", debugCode);
    errorData.put("debugMessage", debugMessage);
    return errorData;
  }

  public static Map<String, String> getCallbackErrorObject(String code, String message, String debugCode, String debugMessage) {
    Map<String, String> errorObject = new LinkedHashMap<>();
    errorObject.put("code", code);
    errorObject.put("message", message);
    errorObject.put("debugCode", debugCode);
    errorObject.put("debugMessage", debugMessage);
    return errorObject;
  }

  public static <T> T checkNotNull(T reference, String errorMessage) {
    if (reference == null) {
      throw new NullPointerException(errorMessage);
    }
    return reference;
  }
}
