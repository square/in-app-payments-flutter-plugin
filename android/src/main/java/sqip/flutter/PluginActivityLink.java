package sqip.flutter;

import android.app.Activity;

import io.flutter.plugin.common.PluginRegistry;

public interface PluginActivityLink {
    Activity getActivity();

    void addListener(PluginRegistry.ActivityResultListener listener);
}
