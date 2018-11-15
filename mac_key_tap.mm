#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#include "mac_key_tap.h"

using namespace v8;

Nan::Persistent<Function> MacKeyTap::persistentCallback;
Nan::Persistent<Function> MacKeyTap::constructor;
bool MacKeyTap::listening = false;

NAN_MODULE_INIT(MacKeyTap::Init) {
  Local<FunctionTemplate> tpl = Nan::New<FunctionTemplate>(New);
  tpl->SetClassName(Nan::New("MacKeyTap").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(8);

  Nan::SetMethod(tpl->InstanceTemplate(), "setCallback", SetCallback);
  Nan::SetMethod(tpl->InstanceTemplate(), "isListening", IsListening);

  constructor.Reset(Nan::GetFunction(tpl).ToLocalChecked());
  Nan::Set(target, Nan::New("MacKeyTap").ToLocalChecked(), Nan::GetFunction(tpl).ToLocalChecked());
}

CGEventRef
myCGEventCallback(CGEventTapProxy proxy, CGEventType type,
                  CGEventRef event, void *refcon)
{
    if ((type != kCGEventKeyDown) && (type != kCGEventKeyUp))
      return event;

    CGKeyCode keycode = (CGKeyCode)CGEventGetIntegerValueField(
                                       event, kCGKeyboardEventKeycode);

    v8::Isolate* isolate = v8::Isolate::GetCurrent();
    Local<Function> f = Local<Function>::New(isolate, MacKeyTap::persistentCallback);
    f->Call(isolate->GetCurrentContext()->Global(), 0, {});

    return event;
}

MacKeyTap::MacKeyTap() {
  CFMachPortRef      eventTap;
  CGEventMask        eventMask;
  CFRunLoopSourceRef runLoopSource;

  eventMask = ((1 << kCGEventKeyDown) | (1 << kCGEventKeyUp));
  eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault,
                              eventMask, myCGEventCallback, NULL);
  if (!eventTap) {
    MacKeyTap::listening = false;
    return;
  }

  MacKeyTap::listening = true;

  runLoopSource = CFMachPortCreateRunLoopSource(
                      kCFAllocatorDefault, eventTap, 0);

  CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource,
                      kCFRunLoopCommonModes);

  CGEventTapEnable(eventTap, true);
}

MacKeyTap::~MacKeyTap() {
}

NAN_METHOD(MacKeyTap::New) {
  if (info.IsConstructCall()) {
    
    MacKeyTap *keyTap = new MacKeyTap();
    keyTap->Wrap(info.This());
    info.GetReturnValue().Set(info.This());
  } else {
    const int argc = 1;
    Local<Value> argv[argc] = {info[0]};
    Local<Function> cons = Nan::New(constructor);
    info.GetReturnValue().Set(Nan::NewInstance(cons, argc, argv).ToLocalChecked());
  }
}

NAN_METHOD(MacKeyTap::SetCallback) {
  Handle<Function> cb = Handle<Function>::Cast(info[0]);
  persistentCallback.Reset(cb);

  info.GetReturnValue().SetUndefined();
}

NAN_METHOD(MacKeyTap::IsListening) {
  info.GetReturnValue().Set(MacKeyTap::listening);
}
