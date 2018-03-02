require 'mqtt'
# Set your MQTT server
MQTT_SERVER = 'mqtt://icinga2-iot'
# Set the MQTT topics you're interested in and the tag (data-id) to send for dashing events
MQTT_TOPICS = {
	'/sensor/hallway/doorbell/battery' => 'hallway-doorbell-battery',
	'/sensor/living-room/temp/battery' => 'living-room-temp-battery',
	'/sensor/living-room/temp/degrees' => 'living-room-temp-degrees',
	'/sensor/bed-room/temp/degrees' => 'bed-room-temp-degrees',
              }

# Start a new thread for the MQTT client
Thread.new {
  MQTT::Client.connect(MQTT_SERVER) do |client|
    client.subscribe( MQTT_TOPICS.keys )

    # Sets the default values to 0 - used when updating 'last_values'
    current_values = Hash.new(0)

    client.get do |topic,message|
      tag = MQTT_TOPICS[topic]
      last_value = current_values[tag]
      current_values[tag] = message
      send_event(tag, { value: message, current: message, last: last_value })
    end
  end
}
