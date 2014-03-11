require 'spec_helper'

describe Lita::Handlers::Datadog, lita_handler: true do
  it { routes_command('graph metric:"system.load.1{*}"').to(:simple_metric) }
  it { routes_command('graph metric:"system.load.1{*},system.load.5{*}"').to(:simple_metric) }

  describe '.default_config' do
    it 'sets the api_key to nil' do
      expect(Lita.config.handlers.datadog.api_key).to be_nil
    end

    it 'sets the application_key to nil' do
      expect(Lita.config.handlers.datadog.application_key).to be_nil
    end

    it 'sets the default_timerange to 3600' do
      expect(Lita.config.handlers.datadog.default_timerange).to eq(3600)
    end
  end

  describe '#simple_metric' do
    it 'with valid metric returns an image url' do
      response = { 'snapshot_url' => 'http://www.example.com/path/that/ends/in.png' }
      allow_any_instance_of(Lita::Handlers::Datadog).to \
        receive(:graph_snapshot).with(any_args).and_return([200, response])
      send_command('graph metric:"system.load.1{*}"')
      expect(replies.last).to eq('http://www.example.com/path/that/ends/in.png')
    end

    it 'with invalid metric returns an error' do
      allow_any_instance_of(Lita::Handlers::Datadog).to \
        receive(:graph_snapshot).with(any_args).and_return([500, nil])
      send_command('graph metric:"omg.wtf.bbq{*}"')
      expect(replies.last).to eq('Error requesting Datadog graph')
    end
  end
end
