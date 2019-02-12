require_relative '../lib/siap_exporter'

comprobantes = [{
  fecha: '2016-07-04',
  denominacion_comprador: 'Tito Puente',
  numero_identificacion_comprador: 27224686604,
  tipo_comprobante: 'A',
  punto_de_venta: 4,
  numero_comprobante: 1220,
  gravado_21: 144950,
  iva_21: 30440,
  no_gravado: 1873400,
  exento: 1765741,
  total: 3814531
}, {
  fecha: '2016-07-01',
  denominacion_vendedor: 'BUSINESS & TRAVEL SRL',
  numero_identificacion_vendedor: 30642724459,
  tipo_comprobante: 'A',
  punto_de_venta: 1,
  numero_comprobante: 44391,
  gravado_21: 177856,
  iva_21: 37350,
  gravado_10: 0,
  iva_10: 0,
  no_gravado: 2057422,
  exento: 16,
  ## ESTOS CAMPOS TAMBIEN PUEDEN CAMBIAR ##
  moneda: 'PES',
  cambio: 1000000, 
  a_cuenta_iva: 0, 
  impuestos_nacionales: 0,
  ingresos_brutos: 0,
  impuestos_municipales: 0,
  impuestos_internos: 0,
  credito_fiscal: 0, 
  otros_tributos: 0
}]

compras = <<SIAP.chomp
201607010010000100000000000000044391                8000000000030642724459BUSINESS & TRAVEL SRL         000000002272644000000002057422000000000000016000000000000000000000000000000000000000000000000000000000000000000000000000PES00010000001000000000000000000000000000000000000000000                              000000000000000
SIAP

alicuotas_compras = <<SIAP.chomp
001000010000000000000004439180000000000306427244590000000001778560005000000000037350
SIAP

ventas = <<SIAP.chomp
201607040010000400000000000000001220000000000000000012208000000000027224686604Tito Puente                   000000003814531000000001873400000000000000000000000001765741000000000000000000000000000000000000000000000000000000000000PES00010000001000000000000000000000000
SIAP

alicuotas_ventas = <<SIAP.chomp
00100004000000000000000012200000000001449500005000000000030440
SIAP

files = SiapExporter::ComprasVentas.generate(comprobantes)

def assert_equal actual, expected
  return success if actual == expected
  puts
  puts actual
  puts '!='
  puts expected
  flunk 'does not match'
end

assert_equal ventas, files[:ventas]
assert_equal alicuotas_ventas, files[:alicuotas_ventas]
assert_equal compras, files[:compras]
assert_equal alicuotas_compras, files[:alicuotas_compras]
