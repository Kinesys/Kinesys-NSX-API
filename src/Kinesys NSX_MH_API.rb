require 'rubygems'
require 'json'
require 'net/https'
require 'uri'

class NsxController

    def initialize(host, port = 443, username = 'admin', password = 'admin')
        @host = host
        @port = port 
        @username = username
        @password = password
        @prefix = "https://#{@host}:#{@port}/wS.v1"
        @cookie = ''

    end

    def login

        uri = URI.parse("#{@prefix}/login")
        web = https(uri)

        web.start {

            response = web.post(uri.path, "username=#{@username}&password=#{@password}")

            @cookie = response.get_fields( 'Set-Cookie' )[0]

        }

    end

    def logout
        
        uri = URI.parse("#{@prefix}/logout")
        web = https(uri)

        web.start {

            response = web.get(uri.path, {'Cookie' => @cookie})

        }
    
    end

    def create_transport_zone(body={})

        api("/transport-zone", :post, body)

    end

    def delete_transport_zone(zone_uuid)

        api("/transport-zone/#{zone_uuid}", :delete)

    end
    
    def create_logical_switch(body={})

        api("/Iswitch", :post, body)

    end

    def delete_logical_switch(lswitch_uuid)

        api("/lswitch/#{lswitch_uuid}", :delete)

    end

    def query_logical_switches()

        api("/lswitch", :get)

    end

    def create_logical_switch_port(lswitch_uuid, body={})

        api("/lswitch/#{lswitch_uuid}/lport", :post, body)

    end

    def delete_logical_switch_port(lswitch_uuid, lport_uuid)

        api("/lswitch/#{lswitch_uuid}/lport/#{lport_uuid}", :delete)

    end

    def update_logical_switch_port_attachment(lswitch_uuid, lport_uuid, body={})

        api("/lswitch/#{lswitch_uuid}/lport#{lport_uuid}/attachment", :put, body)

    end

    def import_switch_control_server_certificate(pem_encoded, rsa_private_key)

        api("/control-cluster/switch-certificate", :put,
        {:certificate => {:pem_encoded => pem_encoded}, :rsa_private_key => rsa_private_key})

    end

    private

    def https(uri)

        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        https

    end

    def api(path, method, body={})

        uri = URI.parse("#{@prefix}#{path}")   

        web = https(uri)

        web.start {
            case method
            
            when :get
                response = web.get(uri.path, {'Cookie' => @cookie})
            when :post
                response = web.post(uri.path, JSON.generate(body), {'Cookie' => @cookie})
            when :put
                response = web.put(uri.path, JSON.generate(body), {'Cookie' => @cookie})
            when :delete
                response = web.delete(uri.path, {'Cookie' => @cookie})
            else
                raise "unsupported method #{method}"
            end
            
            if response.body
                JSON.parse(response.body)
            else
                {}
            end
        }
    end

end
