require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'lita/helpers/utilities'
require 'lita/helpers/graphs'
require 'lita/handlers/datadog'

require 'dogapi'
require 'chronic'
