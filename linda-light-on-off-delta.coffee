process.env.LINDA_BASE  ||= 'http://linda-server.herokuapp.com'
process.env.LINDA_SPACE ||= 'masuilab'

_ = require 'lodash'

## Linda
LindaClient = require('linda').Client
socket = require('socket.io-client').connect(process.env.LINDA_BASE)
linda = new LindaClient().connect(socket)
ts = linda.tuplespace(process.env.LINDA_SPACE)

linda.io.on 'connect', ->
  console.log "connect!! <#{process.env.LINDA_BASE}/#{ts.name}>"

  ts.watch {where: 'delta', name: 'light', cmd: 'on'}, (err, tuple) ->
    return if err
    console.log tuple
    return if tuple.data.response?
    ts.take {where: 'delta', type: 'sensor', name: 'light'}, (err, tuple) ->
      if tuple.data.value > 100
        console.log "すでに電気ついてる"
        return
      else
        light_on_throttled ->
          ts.write {where: 'delta', name: 'light', response: 'success', cmd: 'on'}

  ts.watch {where: 'delta', name: 'light', cmd: 'off'}, (err, tuple) ->
    return if err
    console.log tuple
    return if tuple.data.response?
    ts.take {where: 'delta', type: 'sensor', name: 'light'}, (err, tuple) ->
      if tuple.data.value < 100
        console.log "すでに電気消えてる"
        return
      else
        light_on_throttled ->
          ts.write {where: 'delta', name: 'light', response: 'success', cmd: 'off'}

linda.io.on 'disconnect', ->
  console.log "socket.io disconnect.."


## Arduino
ArduinoFirmata = require('arduino-firmata')
arduino = new ArduinoFirmata().connect(process.env.ARDUINO)

arduino.once 'connect', ->
  console.log "connect!! #{arduino.serialport_name}"
  console.log "board version: #{arduino.boardVersion}"

light_on = (onComplete = ->) ->
  arduino.servoWrite 8, 45
  setTimeout ->
    arduino.servoWrite 8, 0
    onComplete()
    arduino.servoWrite 9, 0
    setTimeout ->
      arduino.servoWrite 9, 45
      onComplete()
    , 500
  , 500

light_on_throttled = _.throttle light_on, 5000, trailing: false
