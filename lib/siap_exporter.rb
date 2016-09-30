require 'fixed_width_dsl'

module SiapExporter
  TIPO_COMPROBANTE = {
    'A'   => 1,
    'B'   => 6,
    'NCA' => 3
  }
  TIPO_ALICUOTA = {
    5 => [:gravado_21, :iva_21],
    4 => [:gravado_10, :iva_10]
  }

  class ComprasVentas

    AlicuotaVenta = FixedWidthDSL.define do
      field :tipo_comprobante,    3,   :integer,  '0'
      field :punto_de_venta,      5,   :integer,  '0'
      field :numero_comprobante,  20,  :integer,  '0'
      field :gravado,             15,  :integer,  '0'
      field :tipo_alicuota,       4,   :integer,  '0'
      field :impuesto,            15,  :integer,  '0'
    end

    Venta = FixedWidthDSL.define do
      field :fecha,                            8,   :integer,  '0'
      field :tipo_comprobante,                 3,   :integer,  '0'
      field :punto_de_venta,                   5,   :integer,  '0'
      field :numero_comprobante,               20,  :integer,  '0'
      field :numero_comprobante_hasta,         20,  :integer,  '0'
      field :codigo_documento_comprador,       2,   :integer,  '0'
      field :numero_identificacion_comprador,  20,  :integer,  '0'
      field :denominacion_comprador,           30,  :string,   '-'
      field :total,                            15,  :integer,  '0'
      field :no_gravado,                       15,  :integer,  '0'
      field :no_categorizados,                 15,  :integer,  '0'
      field :exento,                           15,  :integer,  '0'
      field :impuestos_nacionales,             15,  :integer,  '0'
      field :ingresos_brutos,                  15,  :integer,  '0'
      field :impuestos_municipales,            15,  :integer,  '0'
      field :impuestos_internos,               15,  :integer,  '0'
      field :moneda,                           3,   :string,   '0'
      field :cambio,                           10,  :integer,  '0'
      field :cantidad_de_alicuotas,            1,   :integer,  '0'
      field :codigo_de_operacion,              1,   :integer,  '0'
      field :otros_tributos,                   15,  :integer,  '0'
      field :vencimiento_de_pago,              8,   :integer,  '0'
    end

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
        # las alicuotas se deben generar antes que la venta, porque la
        # cantidad se indica en el registro de venta
        alicuotas_venta(comprobante)
        venta(comprobante)
      end
      {
        ventas: @ventas.join("\n"),
        alicuotas_ventas: @alicuotas_ventas.join("\n")
      }
    end

    private

    def alicuotas_venta comprobante
      comprobante[:cantidad_de_alicuotas] = 0
      TIPO_ALICUOTA.each do |id, claves|
        gravado = comprobante[claves[0]]
        if gravado
          alicuota = comprobante.merge(
            tipo_comprobante: tipo_comprobante(comprobante[:tipo_comprobante]),
            gravado: gravado,
            tipo_alicuota: id,
            impuesto: comprobante[claves[1]])
          @alicuotas_ventas << AlicuotaVenta.apply(alicuota)
          comprobante[:cantidad_de_alicuotas] += 1
        end
      end
    end

    def venta comprobante
      comprobante = comprobante.merge(
        fecha: comprobante[:fecha].gsub('-', ''),
        tipo_comprobante: tipo_comprobante(comprobante[:tipo_comprobante]),
        numero_comprobante_hasta: comprobante[:numero_comprobante],
        codigo_documento_comprador: 80,
        total: total(comprobante),
        no_categorizados: 0,
        impuestos_nacionales: 0,
        ingresos_brutos: 0,
        impuestos_municipales: 0,
        impuestos_internos: 0,
        moneda: 'PES',
        cambio: 1000000,
        codigo_de_operacion: 0,
        otros_tributos: 0,
        vencimiento_de_pago: 0)
      @ventas << Venta.apply(comprobante)
    end

    def tipo_comprobante tipo
      TIPO_COMPROBANTE.fetch(tipo)
    end

    def total comprobante
      comprobante.values_at(:gravado_21, :iva_21, :gravado_10, :iva_10,
                             :no_gravado, :exento).compact.reduce(0, :+)
    end
  end
end
