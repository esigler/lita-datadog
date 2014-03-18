require 'dogapi'
require 'chronic'

module Lita
  module Handlers
    class Datadog < Handler
      route(
        /^graph\s(.*)$/,
        :graph,
        command: true,
        help: { 'graph metric:"simple.metric.1{*},simple.metric.5{*}"' =>
          'Graph those metrics, for the default time range' }
      )

      def self.default_config(config)
        config.api_key = nil
        config.application_key = nil
        config.timerange = 3600
        config.waittime = 0
      end

      def graph(response)
        args = parse_arguments(response.matches[0][0])
        return_code, snapshot = graph_snapshot(args[:metric], args[:start],
                                               args[:end], args[:event])
        if return_code.to_s == '200'
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

      def parse_arguments(arg_string)
        end_m    = /(to|end):"(.+?)"/.match(arg_string)
        end_ts   = end_m ? Chronic.parse(end_m[2]).to_i : Time.now.to_i
        start_m  = /(from|start):"(.+?)"/.match(arg_string)
        start_ts = start_m ? Chronic.parse(start_m[2]).to_i : end_ts - Lita.config.handlers.datadog.timerange
        metric_m = /metric:"(.+?)"/.match(arg_string)
        metric   = metric_m ? metric_m[1] : 'system.load.1{*}'
        event_m  = /event:"(.+?)"/.match(arg_string)
        event    = event_m ? event_m[1] : ''
        { metric: metric,
          start: start_ts,
          end: end_ts,
          event: event }
      end
    end

    Lita.register_handler(Datadog)
  end
end
