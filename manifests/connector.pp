# @summary Add a connector to the OpenTelemetry Collector configuration
#
# @param name
#   The name of the connector
# @param config
#   The configuration of the connector
# @param order
#   The order of the connector
# @param pipelines
#   The pipelines the connector is part of
# @example basic connector
#   otelcol::connector { 'namevar': }
# @example Define a connector and attach it to a pipeline
#   otelcol::connector { 'spanmetrics':
#     pipelines => ['metrics'],
#   }
define otelcol::connector (
  Hash $config = {},
  Integer[0,999] $order = 0,
  Array[String[1]] $pipelines = [],
) {
  $real_order = 1500+$order
  otelcol::component { "${name}-connectors":
    order          => $real_order,
    config         => $config,
    pipelines      => $pipelines,
    component_name => $name,
    type           => 'connectors',
  }
}
