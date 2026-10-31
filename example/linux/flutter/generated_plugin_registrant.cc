//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <clue_map/googlemaparea_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) clue_map_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GooglemapareaPlugin");
  googlemaparea_plugin_register_with_registrar(clue_map_registrar);
}
