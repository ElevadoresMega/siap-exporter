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

scope 'factura b' do
  factura_b = comprobante.merge(tipo_comprobante: 'B')
  venta = SiapExporter::ComprasVentas.generate([factura_b])[:ventas]
  assert venta.match('006'), 'Factura B funciona'
end

scope 'nota de credito' do 
  nca = comprobante.merge(tipo_comprobante: 'NCA')
  venta = SiapExporter::ComprasVentas.generate([nca])[:ventas]
  assert venta.match('003'), 'Nota Credito A funciona'
end

scope 'calcula el total' do
  venta = SiapExporter::ComprasVentas.generate([comprobante])[:ventas]
  assert venta.match('3814531'), 'calcula el total'
end
