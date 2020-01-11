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
package sqip.flutter;

import android.app.Activity;

import java.util.HashMap;
import java.util.ArrayList;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import sqip.InAppPaymentsSdk;
import sqip.BuyerAction;
import sqip.Contact;
import sqip.Country;
import sqip.Currency;
import sqip.Money;
import sqip.SquareIdentifier;
import sqip.SquareIdentifier.LocationToken;
import sqip.flutter.internal.CardEntryModule;
import sqip.flutter.internal.GooglePayModule;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public class SquareInAppPaymentsFlutterPlugin implements FlutterPlugin, ActivityAware {
  private  MethodChannel channel;
  private CallHandler methodCallHandler;
  private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;


  /** Plugin registration. Used to support old pre 1.12 flutter Android projects  */
  public static void registerWith(Registrar registrar) {
    SquareInAppPaymentsFlutterPlugin plugin =  new SquareInAppPaymentsFlutterPlugin();
    plugin.configureMethodChannel(new RegistrarActivityAccessor(registrar), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
  }

  @Override
  public void onDetachedFromEngine(FlutterPlugin.FlutterPluginBinding binding) {
    teardownMethodChannel();
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    configureMethodChannel(new ActivityAccessor(binding), flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromActivity() {

    methodCallHandler.setActivityLink(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  private SquareInAppPaymentsFlutterPlugin() {

  }

  private void configureMethodChannel(PluginActivityLink activityLink, BinaryMessenger messenger) {
    channel = new MethodChannel(messenger, "square_in_app_payments");
    this.methodCallHandler = new CallHandler(activityLink,channel);
    channel.setMethodCallHandler(this.methodCallHandler);
  }

  private void teardownMethodChannel() {
    channel.setMethodCallHandler(null);
    channel = null;
  }
}
