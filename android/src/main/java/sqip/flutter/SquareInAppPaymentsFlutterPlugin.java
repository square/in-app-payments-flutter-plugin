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

import io.flutter.plugin.common.BinaryMessenger;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

public class SquareInAppPaymentsFlutterPlugin implements FlutterPlugin, ActivityAware {
  private  MethodChannel channel;
  private CallHandler methodCallHandler;


  /** Plugin registration. Used to support old pre 1.12 flutter Android projects  */
  public static void registerWith(Registrar registrar) {
    SquareInAppPaymentsFlutterPlugin plugin =  new SquareInAppPaymentsFlutterPlugin();
    plugin.configureMethodChannel(new RegistrarActivityAccessor(registrar), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
    // Gets binary messenger through now deprecated api in order to be backwards compatible
    BinaryMessenger messenger = flutterPluginBinding.getFlutterEngine().getDartExecutor();
    configureMethodChannel(null, messenger);
  }

  @Override
  public void onDetachedFromEngine(FlutterPlugin.FlutterPluginBinding binding) {
    teardownMethodChannel();
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    methodCallHandler.setActivityLink(new ActivityAccessor(binding));
  }

  @Override
  public void onDetachedFromActivity() {
    methodCallHandler.setActivityLink(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    methodCallHandler.setActivityLink(new ActivityAccessor(binding));
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
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
