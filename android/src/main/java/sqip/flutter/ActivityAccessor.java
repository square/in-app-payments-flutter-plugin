package sqip.flutter;

import android.app.Activity;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

public class ActivityAccessor implements PluginActivityLink {
    private ActivityPluginBinding binding;


    ActivityAccessor (ActivityPluginBinding binding){
        this.binding = binding;
    }

    @Override
    public Activity getActivity() {
        return binding.getActivity();
    }

    @Override
    public void addListener(PluginRegistry.ActivityResultListener listener) {
        binding.addActivityResultListener(listener);
    }
}


