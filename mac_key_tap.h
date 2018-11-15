#ifndef NATIVE_EXTENSION_GRAB_H
#define NATIVE_EXTENSION_GRAB_H

#include <nan.h>

using namespace v8;

class MacKeyTap : public Nan::ObjectWrap {
  public:
    static NAN_MODULE_INIT(Init);

    static Nan::Persistent<Function> persistentCallback;
    static bool listening;

  private:
    explicit MacKeyTap();
    ~MacKeyTap();

    static NAN_METHOD(New);
    static NAN_METHOD(SetCallback);
    static NAN_METHOD(IsListening);

    static Nan::Persistent<Function> constructor;
};

#endif
