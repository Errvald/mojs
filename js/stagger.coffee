# ignore coffescript sudo code
### istanbul ignore next ###
h        = require './h'
Timeline = require './tween/timeline'
Tween    = require './tween/tween'
Transit  = require './transit'

class Stagger extends Transit
  isSkipDelta: true
  ownDefaults:
    delay:            'stagger(100)'
    els:              null
    fill:             'transparent'
    stroke:           ['yellow', 'cyan', 'deeppink']
    strokeDasharray:  '100%'
    strokeDashoffset: '100%': '0%'
    isShowInit:       false
    isShowEnd:        false
    radius:           0

  vars:->
    h.extend(@ownDefaults, @defaults); @defaults = @ownDefaults
    super; @parseEls()

  extendDefaults:(o)->
    @props = {}; @deltas = {}; fromObj = o or @o
    for key, value of @defaults
      @props[key] = if fromObj[key]? then fromObj[key] else @defaults[key]

  parseEls:->
    if @props.els + '' is '[object NodeList]'
      @props.els = Array::slice.call @props.els, 0
    else if typeof @props.els is 'string'
      els = document.querySelector @props.els
      @props.els = h.getChildElements els
    else if h.isDOM(@props.els)
      @props.els = h.getChildElements @props.els

  createBit:->
    @transits = []; len = @props.els.length
    for i in [0...len]
      # cover the index set
      option = @getOption(i); option.index = i; option.isRunLess = true
      @transits.push new Transit option

  getOption:(i)->
    option = {}
    for key, value of @props
      option[key] = @getPropByMod(key, i)
    option.bit = @getPropByMod('els', i)
    option

  getPropByMod:(name, i)->
    prop = @props[name]; if h.isArray(prop) then prop[i % prop.length] else prop

  render:-> @createBit(); @setProgress(0, true); @createTween(); @
  isDelta:-> false
  createTween:->
    # optimization TODO:
    # the stagger doesnt need the self timeline
    @tween = new Tween
    i = -1
    while(i++ < @transits.length-1)
      @tween.add(@transits[i].tween)
    !@o.isRunLess and @startTween()

  # setProgress:->
  # calcSize:->
  draw:-> @drawEl()

### istanbul ignore next ###
if (typeof define is "function") and define.amd
  define "Stagger", [], -> Stagger
### istanbul ignore next ###
if (typeof module is "object") and (typeof module.exports is "object")
  module.exports = Stagger
### istanbul ignore next ###
window?.mojs ?= {}
### istanbul ignore next ###
window?.mojs.Stagger = Stagger
