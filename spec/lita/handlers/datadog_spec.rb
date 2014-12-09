require 'spec_helper'

describe Lita::Handlers::Datadog, lita_handler: true do
  EXAMPLE_IMAGE_URL = 'http://www.example.com/path/that/ends/in.png'
  EXAMPLE_ERROR_MSG = 'Error requesting Datadog graph'

  it do
    is_expected.to route_command('graph metric:"system.load.1{*}"').to(:graph)
    is_expected.to route_command('graph metric:"system.load.1{host:hostname01}"').to(:graph)
    is_expected.to route_command('graph metric:"system.load.1{*},system.load.5{*}"').to(:graph)
    is_expected.to route_command('graph metric:"system.load.1{*}" event:"sources:something"').to(:graph)
    # is_expected.to route_command('datadog search:"host:hostname01"').to(:graph)
  end

  describe '.default_config' do
    it 'sets the api_key to nil' do
      expect(Lita.config.handlers.datadog.api_key).to be_nil
    end

    it 'sets the application_key to nil' do
      expect(Lita.config.handlers.datadog.application_key).to be_nil
    end

    it 'sets the timerange to 3600' do
      expect(Lita.config.handlers.datadog.timerange).to eq(3600)
    end

    it 'sets the waittime to 0' do
      expect(Lita.config.handlers.datadog.waittime).to eq(0)
    end
  end

  describe '#graph' do
    it 'with valid metric returns an image url' do
      response = { 'snapshot_url' => EXAMPLE_IMAGE_URL }
      allow_any_instance_of(Lita::Handlers::Datadog).to \
        receive(:graph_snapshot).with(any_args).and_return([200, response])
      send_command('graph metric:"system.load.1{*}"')
      expect(replies.last).to eq(EXAMPLE_IMAGE_URL)
    end

    it 'with invalid metric returns an error' do
      allow_any_instance_of(Lita::Handlers::Datadog).to \
        receive(:graph_snapshot).with(any_args).and_return([500, nil])
      send_command('graph metric:"omg.wtf.bbq{*}"')
      expect(replies.last).to eq(EXAMPLE_ERROR_MSG)
    end

    it 'with valid metric and event returns an image url' do
      response = { 'snapshot_url' => EXAMPLE_IMAGE_URL }
      allow_any_instance_of(Lita::Handlers::Datadog).to \
        receive(:graph_snapshot).with(any_args).and_return([200, response])
      send_command('graph metric:"system.load.1{*}"')
      expect(replies.last).to eq(EXAMPLE_IMAGE_URL)
    end

    it 'with an invalid metric returns an error' do
      allow_any_instance_of(Lita::Handlers::Datadog).to \
        receive(:graph_snapshot).with(any_args).and_return([500, nil])
      send_command('graph metric:"omg.wtf.bbq{*}" event:"sources:sourcename"')
      expect(replies.last).to eq(EXAMPLE_ERROR_MSG)
    end

    it 'with an invalid event returns an error' do
      allow_any_instance_of(Lita::Handlers::Datadog).to \
        receive(:graph_snapshot).with(any_args).and_return([500, nil])
      send_command('graph metric:"system.load.1{*}" event:"omg:wtf"')
      expect(replies.last).to eq(EXAMPLE_ERROR_MSG)
    end
  end
end
