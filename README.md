# [WIP] siap-exporter

Exportador para aplicativos del SIAp de AFIP.

La idea es generar archivos para ser importados felizmente por el SIAp, en
particular, el aplicativo "Régimen Informativo de Compras y Ventas".

El exporter, toma una serie de comprobantes en formato símil-JSON (el formato
no está fijo aún)

```ruby
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
  exento: 1765741,
  total: 3814531
}
```

A partir de los datos de los comprobantes, genera los cuatro archivos que
pueden ser importados en el aplicativo de compras y ventas.

files = SiapExporter::ComprasVentas.generate(comprobantes)

```ruby
puts files[:compras].each_line.first
# => "201607040010000400000000000000001220000000000000000012208000000000027..."

puts files[:alicuotas_compras].each_line.first
# => "00100004000000000000000012200000000001449500005000000000030440"
```
