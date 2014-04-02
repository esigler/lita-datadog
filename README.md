# lita-datadog

[![Build Status](https://travis-ci.org/esigler/lita-datadog.png?branch=master)](https://travis-ci.org/esigler/lita-datadog)
[![Code Climate](https://codeclimate.com/github/esigler/lita-datadog.png)](https://codeclimate.com/github/esigler/lita-datadog)
[![Coverage Status](https://coveralls.io/repos/esigler/lita-datadog/badge.png)](https://coveralls.io/r/esigler/lita-datadog)

Interact with Datadog (https://www.datadoghq.com/).

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

### Searching metrics:

A basic search to see all of the metrics for a host:
```
Lita datadog search:"host:hostname01"
```

Time descriptions are parsed by https://github.com/mojombo/chronic

## License

[MIT](http://opensource.org/licenses/MIT)
