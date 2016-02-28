module Lita
  module Helpers
    # Helpers for different ways to generate a graph
    module Graphs
      def snapshot(args)
        url = get_graph_url(args[:metric],
                            args[:start],
                            args[:end],
                            args[:event])

        return t('errors.request') if url.nil?
        # NOTE: Is this still needed?
        sleep config.waittime
        url['snapshot_url']
      end
    end
  end
end
