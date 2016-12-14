def remove_lines(file, words)
  new_lines = ''
  File.open(file, 'r') do |f|
    f.each_line do |line|
      new_lines << line unless words.any? { |word| line.include? word }
    end
  end
  new_lines
end

gems = remove_lines('Gemfile', ['sqlite3', 'turbolinks'])
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
run 'rm -rf test'
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

scripts = remove_lines('app/assets/javascripts/application.js', ['turbolinks'])
run 'rm app/assets/javascripts/application.js'
run 'touch \'app/assets/javascripts/application.js\''
File.open('app/assets/javascripts/application.js', 'w') { |file| file.write(scripts) }
