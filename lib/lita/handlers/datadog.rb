require 'dogapi'

module Lita
  module Handlers
    class Datadog < Handler
      route(
        /^graph\smetric:"(\S+)"$/,
        :graph,
        command: true,
        help: { 'graph metric:"simple.metric.1{*},simple.metric.5{*}"' =>
          'Graph those metrics, for the default time range' }
      )

      route(
        /^graph\smetric:"(\S+)"\sevent:"(\S+)"$/,
        :graph,
        command: true,
        help: { 'graph metric:"simple.metric.1{*}" event:"sources:somename"' =>
          'Graph those metrics with specified events, for the default time range' }
      )

      def self.default_config(config)
        config.api_key = nil
        config.application_key = nil
        config.timerange = 3600
        config.waittime = 1
      end

      def graph(response)
        metric = response.matches[0][0]
        event  = (response.matches[0].count >= 2) ? response.matches[0][1] : ''
        end_ts = Time.now.to_i
        start_ts = end_ts - Lita.config.handlers.datadog.timerange
        _return_code, snapshot = graph_snapshot(metric, start_ts, end_ts, event)
        if snapshot
          sleep Lita.config.handlers.datadog.waittime
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
