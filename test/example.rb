$LOAD_PATH << File.join(__dir__, '../lib')

require 'siap_exporter'

comprobantes = [{
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
}]

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

files = SiapExporter::ComprasVentas.generate(comprobantes)

assert_equal ventas, files[:ventas], 'produce ventas'
assert_equal alicuotas_ventas, files[:alicuotas_ventas],
  'produce alicuotas de ventas'
