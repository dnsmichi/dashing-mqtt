# Dashing with MQTT

#### Table of Contents

1. [Introduction](#introduction)
2. [Support](#support)
3. [License](#license)
4. [Requirements](#requirements)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [Run](#run)
7. [Authors](#authors)
8. [Troubleshooting](#troubleshooting)

## Introduction

[Dashing](http://shopify.github.io/dashing/) is a Sinatra based framework
that lets you build beautiful dashboards.

You can put your important infrastructure stats and metrics on your office
dashboard. Data can be pulled with custom jobs or pushed via REST API. You can re-arrange
widgets via drag&drop. Possible integrations include [Icinga](https://www.icinga.com/), [Grafana](https://grafana.com/),
ticket systems such as [RT](https://bestpractical.com/request-tracker/) or [OTRS](https://www.otrs.com),
[sensors](https://shop.netways.de/), [weather](https://github.com/Shopify/dashing/wiki/Additional-Widgets),
[schedules](https://blog.netways.de/2013/06/21/netrp-netways-resource-planner/),
etc. -- literally anything which can be presented as counter or list.

### MQTT Dashboard

The MQTT dashboard is built on top of Dashing and connects to an MQTT broker fetching
specific events. These updates are sent to the MQTT dashboards.

## Support

You are encouraged to use the existing jobs and dashboards and modify them for your own needs.

If you have any questions, please hop onto [monitoring-portal.org](https://monitoring-portal.org).

## License

* Dashing is licensed under the [MIT license](https://github.com/Shopify/dashing/blob/master/MIT-LICENSE).
* Job and dashboard have been copied from https://gist.github.com/jmb/ac36d16a5180c3d2032a
* Layout and widgets have been imported from [dashing-icinga2](https://github.com/icinga/dashing-icinga2)

## Requirements

* Ruby, Gems and Bundler
* Dashing Gem
* MQTT broker, e.g. Mosquitto

Supported browsers and clients:

* Linux, Unix, \*Pi
* Chrome, Firefox, Safari

Windows is [not supported](https://github.com/Icinga/dashing-icinga2/issues/47).

## Installation

Either clone this repository from GitHub or download the tarball.

Git clone:

```
cd /usr/share
git clone https://github.com/dnsmichi/dashing-mqtt.git
cd dashing-icinga2
```

Tarball download:

```
cd /usr/share
wget https://github.com/dnsmichi/dashing-mqtt/archive/master.zip
unzip master.zip
mv dashing-mqtt-master dashing-mqtt
cd dashing-mqtt
```


### Linux

RedHat/CentOS 7 (requires EPEL repository):

```
yum makecache
yum -y install epel-release
yum -y install rubygems rubygem-bundler ruby-devel openssl gcc-c++ make nodejs
```

Note: The development tools and header files are required for building the `eventmachine` gem.

Debian/Ubuntu:

```
apt-get update
apt-get -y install ruby bundler nodejs
```

Proceed with the `bundler` gem installation for all systems (CentOS, Debian, etc.).

```
gem install bundler
```

In case the installation takes quite long and you do not need any documentation,
add the `--no-document` flags.

Install the dependencies using Bundler.

```
cd /usr/share/dashing-mqtt
bundle
```

Proceed to the [configuration](#configuration) section.

### Unix and macOS

On macOS [OpenSSL was deprecated](https://github.com/eventmachine/eventmachine/issues/602),
therefore you'll need to fix the eventmachine gem:

```
brew install openssl
bundle config build.eventmachine --with-cppflags=-I/usr/local/opt/openssl/include
bundle install --path binpaths
```

Note: Dashing is running inside thin server which by default uses epoll from within the eventmachine library.
This is not available on Unix based systems, you can safely ignore this warning:

```
warning: epoll is not supported on this platform
```

Proceed to the [configuration](#configuration) section.


## Configuration

Edit `jobs/mqtt.rb` and set the MQTT broker details. You also need to update the topic-to-data-id
mapping.

These data-id values are the ones which are referenced in the dashboard widgets in
`dashboards/mqtt.erb`. Edit/update this file for your own needs.


```
vim jobs/mqtt.rb

# Set your MQTT server
MQTT_SERVER = 'mqtt://icinga2-iot'
# Set the MQTT topics you're interested in and the tag (data-id) to send for dashing events
MQTT_TOPICS = {
  '/sensor/hallway/doorbell/battery' => 'hallway-doorbell-battery',
  '/sensor/living-room/temp/battery' => 'living-room-temp-battery',
  '/sensor/living-room/temp/degrees' => 'living-room-temp-degrees',
  '/sensor/bed-room/temp/degrees' => 'bed-room-temp-degrees',
              }
```


## Run

### Systemd Service

Install the provided Systemd service file from `tools/systemd`. It assumes
that the working directory is `/usr/share/dashing-mqtt` and the Dashing gem
is installed to `/usr/local/bin/dashing`. Adopt these paths for your own needs.

```
cp tools/systemd/dashing-mqtt.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl start dashing-mqtt.service
systemctl status dashing-mqtt.service
```


### Script

You can start dashing as daemon by using this script:

```
./restart-dashing
```

Additional options are available through `./restart-dashing -h`.

Navigate to [http://localhost:8006](http://localhost:8006)


### Foreground

You can run Dashing in foreground for tests and debugging too:

```
export PATH="/usr/local/bin:$PATH"
dashing start -p 8006
```

## Authors

* [jmb](https://github.com/jmb)
* [dnsmichi](https://github.com/dnsmichi)

## Troubleshooting

Please add these details when you are asking a question on the community channels.

### Required Information

* Dashing version (`gem list --local dashing`)
* Ruby version (`ruby -V`)
* Version of this project (tarball name, download date, tag name or `git show -1`)
* Your own modifications to this project, if any

### Widgets are not updated

* Open your browser's development console and check for errors.
* Ensure that the job runner does not log any errors.
* Stop the dashing daemon and run it in foreground.

### Connection Errors

* Manually test the MQTT broker
* Modify the `jobs/mqtt.rb` and add additional logging (use `puts` similar to existing examples)
* Run Dashing in foreground

### Misc Errors

* Port 8006 is not reachable. Ensure that the firewall rules are setup accordingly.

