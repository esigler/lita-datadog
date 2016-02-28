module Lita
  module Handlers
    class Datadog < Handler
      config :api_key, required: true
      config :application_key, required: true
      config :timerange, default: 3600
      config :waittime, default: 0

      include Lita::Helpers::Utilities
      include Lita::Helpers::Graphs

      route(
        /^graph\s(?<args>.*)$/,
        :graph,
        command: true,
        help: {
          t('help.graph.syntax') => t('help.graph.desc')
        }
      )

      def graph(response)
        content = snapshot(parse_arguments(response.match_data['args']))
        response.reply(content)
      end
    end

    Lita.register_handler(Datadog)
  end
end
