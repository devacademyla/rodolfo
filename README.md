# Rodolfo
Template para crear una aplicación en rails 5. La mayoría de aplicaciones desarrolladas en devAcademy tienen algunas configuraciones para el entorno de desarollo y de testing, por ello creamos nuestro propio template.

## Gemfile
Las gemas que agrega:
* gem 'haml'
* gem 'pg'
* gem 'sqlite3'
* gem 'rspec-rails'
* gem 'factory_girl_rails'
* gem 'database_cleaner'
* gem 'shoulda-matchers'
* gem 'rubocop'

La gema 'devise' es opcional. Al iniciar la aplicación, se le preguntará si desea agregarla o no

## Uso
Para generar una nueva aplicación usando este template, debe pasar la opción `-m` a `rails new`, como:
```
rails new example -m https://raw.githubusercontent.com/devacademyla/rodolfo/master/template.rb
```
