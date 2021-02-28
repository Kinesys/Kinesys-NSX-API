require 'rubygems'
require 'json'
require 'net/https'
require 'url'

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

        uri = URI.parse("")
