require 'bundler'

Bundler.require(:third_party_service)

require_relative 'app'
run ThirdPartyService
