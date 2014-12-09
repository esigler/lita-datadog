module Lita
  module Handlers
    class Datadog < Handler
      config :api_key, required: true
      config :application_key, required: true
      config :timerange, default: 3600
      config :waittime, default: 0

      route(
        /^graph\s(.*)$/,
        :graph,
        command: true,
        help: { t('help.graph.syntax') => t('help.graph.desc') }
      )

      def graph(response)
        args = parse_arguments(response.matches[0][0])
        response.reply(get_response(args))
      end

      private

      def get_response(args)
        return_code, snapshot = get_graph_url(args[:metric],
                                              args[:start],
                                              args[:end],
                                              args[:event])

        if return_code.to_s == '200'
          sleep config.waittime
          return snapshot['snapshot_url']
        else
          t('errors.request')
        end
      end

      def get_graph_url(metric_query, start_ts, end_ts, event_query)
        client = Dogapi::Client.new(config.api_key, config.application_key)

        return nil unless client

        client.graph_snapshot(metric_query, start_ts, end_ts, event_query)
      end

      def parse_arguments(arg_string)
        end_ts   = parse_end(arg_string)
        start_ts = parse_start(arg_string, end_ts)
        metric   = parse_metric(arg_string)
        event    = parse_event(arg_string)
        { metric: metric, start: start_ts, end: end_ts, event: event }
      end

      def parse_end(string)
        found = /(to|end):"(.+?)"/.match(string)
        found ? Chronic.parse(found[2]).to_i : Time.now.to_i
      end

      def parse_start(string, end_ts)
        found = /(from|start):"(.+?)"/.match(string)
        found ? Chronic.parse(found[2]).to_i : end_ts - config.timerange
      end

      def parse_metric(string)
        found = /metric:"(.+?)"/.match(string)
        found ? found[1] : 'system.load.1{*}'
      end

      def parse_event(string)
        found = /event:"(.+?)"/.match(string)
        found ? found[1] : ''
      end
    end

    Lita.register_handler(Datadog)
  end
end
