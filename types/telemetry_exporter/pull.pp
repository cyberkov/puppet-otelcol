# Type for pull-based telemetry exporters that expose metrics endpoints for external scraping.
type Otelcol::Telemetry_exporter::Pull = Variant[Otelcol::Telemetry_exporter::Pull::Prometheus]
