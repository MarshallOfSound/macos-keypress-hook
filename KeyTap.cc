#include "mac_key_tap.h"

// Notification.cc represents the top level of the module.
// C++ constructs that are exposed to javascript are exported here

NODE_MODULE(KeyTap, MacKeyTap::Init)
