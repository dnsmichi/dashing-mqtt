source 'https://rubygems.org'

# force the most recent dashing version to avoid #48
gem 'dashing', '>= 1.3.7'

# dashing server
gem 'thin'
gem 'eventmachine'

# sinatra pulls rack-protection which pulls rack-test >= 0. v0.8.0 requires Ruby >= 2.2.2 (this fails on RHEL7).
gem 'rack-test', '< 0.8.0'

# MQTT
gem 'mqtt', '>= 0.3.1'
