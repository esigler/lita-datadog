# lita-datadog

[![Build Status](https://img.shields.io/travis/esigler/lita-datadog/master.svg)](https://travis-ci.org/esigler/lita-datadog)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems :: RMuh Gem Version](http://img.shields.io/gem/v/lita-datadog.svg)](https://rubygems.org/gems/lita-datadog)
[![Coveralls Coverage](https://img.shields.io/coveralls/esigler/lita-datadog/master.svg)](https://coveralls.io/r/esigler/lita-datadog)
[![Code Climate](https://img.shields.io/codeclimate/github/esigler/lita-datadog.svg)](https://codeclimate.com/github/esigler/lita-datadog)
[![Gemnasium](https://img.shields.io/gemnasium/esigler/lita-datadog.svg)](https://gemnasium.com/esigler/lita-datadog)

A [Datadog](http://datadoghq.com) plugin for [Lita](https://github.com/jimmycuadra/lita).

## Installation

Add lita-datadog to your Lita instance's Gemfile:

``` ruby
gem "lita-datadog"
```

## Configuration

### Required attributes

You will need a DataDog API key, and an application key.  Go to https://app.datadoghq.com/account/settings#api for both.

Add the following some
```
Lita.configure do |config|
...
  config.handlers.datadog.api_key = '_api_key_goes_here_'
  config.handlers.datadog.application_key = '_app_key_goes_here_'
...
end
```

### Optional attributes

* `timerange` (Integer) - How long in seconds a time range will be for graphs. Default: `3600`
* `waittime` (Integer) - How long to wait after getting a URL from Datadog to display it (sometimes the graph isn't ready yet). Default: `0`

## Usage

### Graphs

Basic graph of the load on all of your systems:

```
Lita graph metric:"system.load.1{*}"
```

Graph of load for one specific system:
```
Lita graph metric:"system.load.1{host:hostname01}"
```

Multiple attributes plotted in one graph:
```
Lita graph metric:"system.load.1{*},system.load.5{*}"
```

Show graph, with events marked in:
```
Lita graph metric:"system.load.1{*}" event:"sources:sourcename"
```

Manipulate time range being graphed:
```
Lita graph metric:"system.load.1{*}" start:"2 hours ago"
Lita graph metric:"system.load.1{*}" from:"2 hours ago" to:"30 minutes ago"
```

Graph takes the following arguments:
```
metric:"<metric>"
event:"<event>"
start:"<time description>"
end:"<time description>"
from:"<time description>"
to:"<time description>"
```

Time descriptions are parsed by https://github.com/mojombo/chronic

## License

[MIT](http://opensource.org/licenses/MIT)
