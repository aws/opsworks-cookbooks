require "json"
require "net/http"

module OpsWorks
  class ECSAgent
    def available?
      Net::HTTP.get(uri)

      true
    rescue StandardError
      false
    end

    def cluster
      metadata.fetch("Cluster")
    rescue KeyError
      Chef::Log.warn("Cluster not found in ECS metadata.")
    end

    def wait_for_availability(attempts = 300)
      attempts.times do
        return true if available?

        sleep 1
      end

      false
    end

    private

    def metadata
      result = Net::HTTP.get(uri)
      JSON.parse(result)
    rescue Errno::ECONNREFUSED
      Chef::Log.warn("Cannot connect to ECS metadata service.")
    rescue JSON::ParserError
      Chef::Log.warn("Cannot parse ECS metadata.")
    rescue StandardError
      Chef::Log.warn("Unknown error occured during ECS metadata lookup.")
    end

    def uri
      URI("http://localhost:51678/v1/metadata")
    end
  end
end
