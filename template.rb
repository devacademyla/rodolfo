gems = ''
File.open('Gemfile', 'r') do |f|
  f.each_line do |line|
    gems << line unless (line.include? 'sqlite3') || (line.include? 'turbolinks')
  end
end
run 'rm Gemfile'
run 'touch \'Gemfile\''
File.open('Gemfile', 'w') { |file| file.write(gems) }

gem 'haml'
gem_group :production do
  gem 'pg'
end

gem_group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'rubocop'
end
run 'rm test'
run 'bundle install'
generate 'rspec:install'
if yes?('Add devise?(yes/no)')
  gem 'devise'
  run 'bundle install'
  generate 'devise:install'
  environment 'config.action_mailer.default_url_options = { host: \'localhost\', port: 3000 }', env: 'development'
  class_name = ask('Model name (e.g. User):')
  params = ask('Aditional params (e.g. \'first_name:string lastname:string\'):')
  generate :devise, [class_name, params].join(' ')
  rails_command 'db:migrate'
  generate 'devise:views'
end
