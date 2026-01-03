# Example using connectors to connect two pipelines
# Connectors are used to connect two pipelines together in OpenTelemetry Collector

# Define a receiver for traces
otelcol::receiver { 'otlp' :
  config    => {
    'protocols' => {
      'grpc' => { 'endpoint' => 'localhost:4317' },
    },
  },
  pipelines => ['traces'],
}

# Define a connector that converts spans to metrics
otelcol::connector { 'spanmetrics' :
  config    => {
    'dimensions' => [
      { 'name' => 'http.method' },
      { 'name' => 'http.status_code' },
    ],
  },
  pipelines => ['metrics'],
}

# Define an exporter for the metrics pipeline
otelcol::exporter { 'prometheus':
  config    => {
    'endpoint' => 'localhost:9090',
  },
  pipelines => ['metrics'],
}

# Define an exporter for the traces pipeline
otelcol::exporter { 'debug':
  config    => { 'verbosity' => 'detailed' },
  pipelines => ['traces'],
}

class { 'otelcol':
  manage_archive => true,
}
