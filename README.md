light-on-off-delta
===============
ON/OFF [DeltaS112](http://gyazz.com/masuilab/慶應SFC 増井研究会) light with [linda-socket.io](https://github.com/node-linda/linda-socket.io)

- https://github.com/node-linda/light-on-off-delta

![](https://embed.gyazo.com/190f269b26c10d58d86d687335fc36ad.gif)

1. watch {where: 'delta', name: 'light', cmd: 'on'}
2. if {where: 'delta', type: 'sensor', name: 'light'} value > 100, light ON
3. then, write {where: 'delta', name: 'light', cmd: 'on', response: 'success'}


Dependencies
------------
- [Arduino Firmata](https://github.com/shokai/arduino_firmata)


## Install Dependencies

    % npm install


## Setup Arduino

Install Arduino Firmata v2.2

    Arduino IDE -> [File] -> [Examples] -> [Firmata] -> [StandardFirmata]

servo motor -> digital pin 8 and 9


## Run

    % npm start

=> http://linda-server.herokuapp.com/test?type=light


## Run with your [linda-server](https://github.com/node-linda/linda)

    % export LINDA_BASE=http://linda-server.herokuapp.com
    % export LINDA_SPACE=test
    % export ARDUINO=/dev/cu.usbserial-device
    % npm start


## Install as Service

    % gem install foreman

for launchd (Mac OSX)

    % sudo foreman export launchd /Library/LaunchDaemons/ --app node-linda-light-on-off-delta -u `whoami`
    % sudo launchctl load -w /Library/LaunchDaemons/node-linda-light-on-off-delta-main-1.plist


for upstart (Ubuntu)

    % sudo foreman export upstart /etc/init/ --app node-linda-light-on-off-delta -d `pwd` -u `whoami`
    % sudo service node-linda-light-on-off-delta start
