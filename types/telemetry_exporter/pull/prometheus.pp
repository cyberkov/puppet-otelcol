# Type for Prometheus pull-based telemetry exporter configuration.
# Defines the host and port where Prometheus metrics are exposed for scraping.
type Otelcol::Telemetry_exporter::Pull::Prometheus = Struct[{
  host => Stdlib::Host,
  port => Stdlib::Port,
}]
