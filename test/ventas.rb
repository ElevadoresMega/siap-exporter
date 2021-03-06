require_relative '../lib/siap_exporter'

comprobante = {
  fecha: '2016-07-04',
  denominacion_comprador: 'Tito Puente',
  numero_identificacion_comprador: 27224686604,
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

scope 'factura b' do
  factura_b = comprobante.merge(tipo_comprobante: 'B')
  venta = generate(factura_b)[:ventas]
  assert venta.match('006'), 'Factura B funciona'
end

scope 'nota de credito' do 
  nca = comprobante.merge(tipo_comprobante: 'NCA')
  venta = generate(nca)[:ventas]
  assert venta.match('003'), 'Nota Credito A funciona'
end

scope 'calcula el total' do
  venta = generate(comprobante)[:ventas]
  assert venta.match('3814531'), 'calcula el total'
end

scope 'solo gravado al 10.5%' do
  comprobante_al_10 = {
    fecha: '2016-07-04',
    denominacion_comprador: 'Tito Puente',
    numero_identificacion_comprador: 27224686604,
    tipo_comprobante: 'A',
    punto_de_venta: 4,
    numero_comprobante: 1220,
    gravado_10: 1000,
    iva_10: 105,
    no_gravado: 1873400,
    exento: 1765741
  }
  alicuotas_ventas = generate(comprobante_al_10)[:alicuotas_ventas]
  assert_equal alicuotas_ventas.lines.size, 1
  assert alicuotas_ventas.match('004')
end

scope 'gravado al 10 y al 21' do
  comprobante = {
    fecha: '2016-07-04',
    denominacion_comprador: 'Tito Puente',
    numero_identificacion_comprador: 27224686604,
    tipo_comprobante: 'A',
    punto_de_venta: 4,
    numero_comprobante: 1220,
    gravado_21: 2000,
    iva_21: 420,
    gravado_10: 1000,
    iva_10: 105,
    no_gravado: 1873400,
    exento: 1768161
  }
  compras_y_ventas = generate(comprobante)
  assert_equal compras_y_ventas[:alicuotas_ventas].lines.size, 2
  assert_equal compras_y_ventas[:ventas][241], '2'
end
