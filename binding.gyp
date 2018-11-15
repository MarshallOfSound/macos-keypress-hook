{
  "targets": [{
    "target_name": "KeyTap",
    "sources": [ ],
    "conditions": [
      ['OS=="mac"', {
        "sources": [
          "KeyTap.cc",
          "mac_key_tap.mm",
        ],
      }]
    ],
    "include_dirs": [
      "<!(node -e \"require('nan')\")"
    ],
    "xcode_settings": {
      "OTHER_CPLUSPLUSFLAGS": ["-std=c++11", "-stdlib=libc++", "-mmacosx-version-min=10.9"],
      "OTHER_LDFLAGS": ["-framework CoreFoundation -framework IOKit -framework AppKit"]
    }
  }]
}