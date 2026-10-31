#include "include/googlemaparea/googlemaparea_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "googlemaparea_plugin.h"

void GooglemapareaPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  googlemaparea::GooglemapareaPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
