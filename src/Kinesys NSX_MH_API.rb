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
