//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <file_selector_windows/file_selector_windows.h>
#include <platform_device_id_windows/platform_device_id_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  PlatformDeviceIdWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PlatformDeviceIdWindowsPlugin"));
}
