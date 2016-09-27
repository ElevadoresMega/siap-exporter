module SiapExporter
  TIPO_FACTURA = {'A'=>1}
  TIPO_ALICUOTA = {'21%'=>5}

  class ComprasVentas

    def self.generate comprobantes
      new(comprobantes).generate
    end

    def initialize comprobantes
      @comprobantes = comprobantes
      @ventas = []
      @alicuotas_ventas = []
    end

    def generate
      @comprobantes.each do |comprobante|
        @ventas << venta(comprobante)
        @alicuotas_ventas << alicuotas_venta(comprobante)
      end
      {
        ventas: @ventas.join("\n"),
        alicuotas_ventas: @alicuotas_ventas.join("\n")
      }
    end

    private

    def alicuotas_venta comprobante
      format '%03d%05d%020d%015d%04d%015d',
        TIPO_FACTURA.fetch(comprobante[:tipo_factura]),
        comprobante[:punto_de_venta],
        comprobante[:factura],
        comprobante[:gravado_21],
        TIPO_ALICUOTA['21%'],
        comprobante[:iva_21]
    end

    def venta comprobante
      fecha = comprobante[:fecha].gsub('-', '')
      cantidad_de_alicuotas = 1
      format '%8d%03d%05d%020d%020d%02d%020d%-30s' \
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
    end
  end
end

