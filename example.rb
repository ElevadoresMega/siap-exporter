comprobante = {
  fecha: '2016-07-04',
  cliente: 'Tito Puente',
  cuit: 27224686604,
  tipo_factura: 'A',
  punto_de_venta: 4,
  factura: 1220,
  gravado_21: 144950,
  iva_21: 30440,
  no_gravado: 1873400,
  exento: 1765741,
  total: 3814531
}

TIPO_FACTURA = {'A'=>1}
TIPO_ALICUOTA = {'21%'=>5}

def proceso comprobante
  alicuotas = format '%03d%05d%020d%015d%04d%015d',
    TIPO_FACTURA.fetch(comprobante[:tipo_factura]),
    comprobante[:punto_de_venta],
    comprobante[:factura],
    comprobante[:gravado_21],
    TIPO_ALICUOTA['21%'],
    comprobante[:iva_21]

  fecha = comprobante[:fecha].gsub('-', '')
  cantidad_de_alicuotas = 1
  ventas = format '%8d%03d%05d%020d%020d%02d%020d%-30s' \
                  '%015d%015d%015d%015d%015d%015d%015d%015d' \
                  'PES0001000000%1d0%015d00000000',
    fecha,
    TIPO_FACTURA.fetch(comprobante[:tipo_factura]),
    comprobante[:punto_de_venta],
    comprobante[:factura],
    comprobante[:factura],
    80,
    comprobante[:cuit],
    comprobante[:cliente],
    comprobante[:total],
    comprobante[:no_gravado],
    comprobante.fetch(:no_categorizado, 0),
    comprobante.fetch(:exento, 0),
    comprobante.fetch(:impuestos_nacionales, 0),
    comprobante.fetch(:ingresos_brutos, 0),
    comprobante.fetch(:impuestos_municipales, 0),
    comprobante.fetch(:impuestos_internos, 0),
    cantidad_de_alicuotas,
    comprobante.fetch(:otros_tributos, 0)
  {
    ventas: ventas, 
    alicuotas: alicuotas
  }
end

ventas = <<SIAP.chomp
201607040010000400000000000000001220000000000000000012208000000000027224686604Tito Puente                   000000003814531000000001873400000000000000000000000001765741000000000000000000000000000000000000000000000000000000000000PES00010000001000000000000000000000000
SIAP

alicuotas_ventas = <<SIAP.chomp
00100004000000000000000012200000000001449500005000000000030440
SIAP

def assert_equal expected, actual, description = nil
  passed = expected == actual
  result = (passed ? 'ok' : 'not ok')
  puts "#{ result } - #{ description }"
  unless passed
    puts "# Expected:"
    expected.each_line { |line| puts "# #{ line }" }
    puts "# Actual:"
    actual.each_line { |line| puts "# #{ line }" }
    exit_code = 1
  end
end

assert_equal ventas, proceso(comprobante)[:ventas], 'produce ventas'
assert_equal alicuotas_ventas, proceso(comprobante)[:alicuotas], 'produce alicuotas'
