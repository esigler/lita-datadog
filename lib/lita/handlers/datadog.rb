require 'dogapi'

module Lita
  module Handlers
    class Datadog < Handler
      route(
        /^graph\smetric:"(\S+)"$/,
        :simple_metric,
        command: true,
        help: { 'graph metric:"simple.metric.1{*},simple.metric.5{*}"' =>
          'Graph those metrics across all events, for the default time range' }
      )

      def self.default_config(config)
        config.api_key = nil
        config.application_key = nil
        config.default_timerange = 3600
      end

      def simple_metric(response)
        metric = response.matches[0][0]
        end_ts = Time.now.to_i
        start_ts = end_ts - Lita.config.handlers.datadog.default_timerange
        _return_code, snapshot = graph_snapshot(metric, start_ts, end_ts, '*')
        if snapshot
          sleep 1  # TODO: Requesting the image immediately causes a blank image to be cached.
          response.reply(snapshot['snapshot_url'])
        else
          response.reply('Error requesting Datadog graph')
        end
      end

      private

      def graph_snapshot(metric_query, start_ts, end_ts, event_query)
        return nil if Lita.config.handlers.datadog.api_key.nil? ||
                      Lita.config.handlers.datadog.application_key.nil?

        client = Dogapi::Client.new(Lita.config.handlers.datadog.api_key,
                                    Lita.config.handlers.datadog.application_key)

        return client.graph_snapshot(metric_query, start_ts, end_ts, event_query) if client
      end
    end

    Lita.register_handler(Datadog)
  end
end
