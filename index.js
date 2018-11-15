const { EventEmitter } = require('events');
const MacKeyTap = require('bindings')('KeyTap').MacKeyTap

const emitter = new EventEmitter();

const tap = new MacKeyTap()
tap.setCallback(() => emitter.emit('keypress'));
emitter.isListening = tap.isListening();

module.exports = emitter;
