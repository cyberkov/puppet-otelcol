# Type for OpenTelemetry Collector telemetry exporter configuration.
# Supports pull-based exporters (e.g., Prometheus) and periodic exporters (e.g., OTLP).
type Otelcol::Telemetry_exporter = Variant[
  Struct[{ 'prometheus' => Otelcol::Telemetry_exporter::Pull }],
  Struct[{ 'otlp' => Otelcol::Telemetry_exporter::Periodic }],
]
