ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Configura as gems listadas no Gemfile.
require 'bootsnap/setup' # Acelera o boot usando cache para carregar mais rápido.
