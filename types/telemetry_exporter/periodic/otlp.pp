# Type for OTLP periodic telemetry exporter configuration.
# Defines the endpoint and protocol for pushing telemetry data via OTLP.
type Otelcol::Telemetry_exporter::Periodic::Otlp = Struct[{
  endpoint => Stdlib::HTTPSUrl,
  protocol => String
}]
