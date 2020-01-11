package sqip.flutter;

import android.app.Activity;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

public class RegistrarActivityAccessor implements PluginActivityLink {
    private PluginRegistry.Registrar registrar;


    RegistrarActivityAccessor (PluginRegistry.Registrar registrar){
        this.registrar = registrar;
    }

    @Override
    public Activity getActivity() {
        return registrar.activity();
    }

    @Override
    public void addListener(PluginRegistry.ActivityResultListener listener) {
        registrar.addActivityResultListener(listener);
    }
}
