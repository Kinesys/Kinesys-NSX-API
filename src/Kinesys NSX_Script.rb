#UUID, Switch 스크립트화
#sudo apt-get install ruby
#sudo apt-get install rubygems
#sudo gem install uuidtools
#sudo gem install json

require 'rubygems'
require 'uuidtools'
require 'nsxapi'

nsx = NsxController.new('컨트롤러 FQDN')

nsx.login

tz_uuid = nsx.create_transport_zone({:display_name => "TransportZone"})["uuid"]

for sw in 1..10 do

    puts "creating switch #{sw} ..."

    ls_uuid = nsx.create_logical_switch({:display_name => "Test Logical Switch #{sw}",
        :transport_zones => [{:zone_uuid => "#{tz_uuid}", :binding_config => {},
        :transport_type => "stt"}]} )["uuid"]

    for pt in 1..3 do

        port_uuid = nvp.create_logical_switch_port(ls_uuid)["uuid"]
        nsx.update_logical_switch_port_attachment(ls_uuid, port_uuid, {
            :type => "VifAttachment",
            :vif_uuid => UUIDTools::UUID.random_create.to_s})

    end

end
