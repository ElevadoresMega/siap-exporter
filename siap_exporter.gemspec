Gem::Specification.new do |s|
  s.name        = 'siap_exporter'
  s.version     = '0.0.3'
  s.summary     = 'Exporta archivos para el SIAp de AFIP'
  s.description = 'Ayuda a generar archivos para poder ser importados en' \
                  'el siap desde ruby.'
  s.authors     = ['Eloy Espinaco', 'Lionel Hsu']
  s.email       = 'eloyesp@gmail.com'
  s.files       = ["lib/siap_exporter.rb"]
  s.homepage    = 'https://github.com/bluelemons/siap-exporter'
  s.license     = 'AGPL-3.0+'

  s.add_runtime_dependency 'fixed_width_dsl', '0.1.1'

  s.add_development_dependency 'cutest', '~> 1.0'
end
