package sqip.flutter.internal;

import android.app.Activity;
import android.content.Intent;

import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import sqip.SecureRemoteCommerce;
import sqip.SecureRemoteCommerceNonceResult;
import sqip.SecureRemoteCommerceParameters;
import sqip.flutter.internal.converter.CardConverter;
import sqip.flutter.internal.converter.CardDetailsConverter;

final public class SecureRemoteCommerceModule {

    private Activity currentActivity;
    private PluginRegistry.ActivityResultListener activityResultListener;
    private final CardDetailsConverter cardDetailsConverter;

    @SuppressWarnings("deprecation")
    public SecureRemoteCommerceModule(PluginRegistry.Registrar registrar, final MethodChannel channel) {
        this(channel);
        currentActivity = registrar.activity();
        registrar.addActivityResultListener(activityResultListener);
    }
    public SecureRemoteCommerceModule(final MethodChannel channel) {
        activityResultListener = createActivityResultListener(channel);
        cardDetailsConverter = new CardDetailsConverter(new CardConverter());
    }

    public void startSecureRemoteCommerce(MethodChannel.Result result, int amount) {
        SecureRemoteCommerceParameters params = new SecureRemoteCommerceParameters(amount);
        SecureRemoteCommerce.createPaymentDataRequest(currentActivity, params);
        result.success(null);
    }

    public void attachActivityResultListener(final ActivityPluginBinding activityPluginBinding, final MethodChannel channel) {
        if (activityResultListener == null) {
            activityResultListener = createActivityResultListener(channel);
        }
        activityPluginBinding.addActivityResultListener(activityResultListener);
        this.currentActivity = activityPluginBinding.getActivity();
    }

    private PluginRegistry.ActivityResultListener createActivityResultListener(MethodChannel channel) {
        return new PluginRegistry.ActivityResultListener() {
            @Override public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
                if (requestCode == SecureRemoteCommerce.DEFAULT_SECURE_REMOTE_COMMERCE_REQUEST_CODE) {
                    SecureRemoteCommerce.handleActivityResult(data, result -> {
                        if(result.isSuccess()){
                            Map<String, Object> mapToReturn = cardDetailsConverter.toMapObject(result.getSuccessValue());
                            channel.invokeMethod("OnMaterCardNonceRequestSuccess", mapToReturn);
                        } else if(result.isError()){
                            SecureRemoteCommerceNonceResult.Error error = result.getErrorValue();
                            Map<String, String> errorMap = ErrorHandlerUtils.getCallbackErrorObject(error.getCode().name(), error.getMessage(), error.getDebugCode(), error.getDebugMessage());
                            channel.invokeMethod("OnMasterCardNonceRequestFailure", errorMap);
                        }
                    });
                }
                return false;
            }
        };
    }
}
