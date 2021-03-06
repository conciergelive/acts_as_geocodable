require "action_controller"

module ActsAsGeocodable
  module RemoteLocation
    # Get the remote location of the request IP using http://hostip.info
    def remote_location
      if request.remote_ip == "127.0.0.1"
        # otherwise people would complain that it doesn't work
        Graticule::Location.new(locality: "localhost")
      else
        Graticule.service(:host_ip).new.locate(request.remote_ip)
      end
    rescue Graticule::Error => error
      logger.warn "An error occurred while looking up the location of '#{request.remote_ip}': #{error.message}"
      nil
    end
  end
end

ActionController::Base.send(:include, ActsAsGeocodable::RemoteLocation)
