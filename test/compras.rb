require_relative '../lib/siap_exporter'

comprobante = {
  fecha: '2016-07-04',
  denominacion_vendedor: 'Tito Puente',
  numero_identificacion_vendedor: 27224686604,
  tipo_comprobante: 'A',
  punto_de_venta: 4,
  numero_comprobante: 1220,
  gravado_21: 144950,
  iva_21: 30440,
  no_gravado: 1873400,
  exento: 1765741
}

def generate comprobante
  SiapExporter::ComprasVentas.generate([comprobante])
end

assert_equal generate(comprobante)[:compras], <<COMPRA.chomp
2016-07-040010000400000000000000001220                8000000000027224686604Tito Puente                   000000003814531000000001873400000000001765741000000000000000000000000000000000000000000000000000000000000000000000000000PES00010000001000000000000000000000000000000000000000000                              000000000000000
COMPRA

assert_equal generate(comprobante)[:alicuotas_compras], <<COMPRA.chomp
001000040000000000000000122080000000000272246866040000000001449500005000000000030440
COMPRA
