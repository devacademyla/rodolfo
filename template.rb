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

gem 'haml-rails'
gem_group :production do
  gem 'pg'
end

gem_group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'eslint-rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'rubocop'
  gem 'simplecov'
end
run 'rm -rf test'
run 'bundle install'
generate 'rspec:install'
rails_command 'eslint:print_config'

run 'rm spec/rails_helper.rb'
run 'rm spec/spec_helper.rb'
run 'touch \'spec/spec_helper.rb\''

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
  file = File.open(File.expand_path(File.join(File.dirname(__FILE__))) +'/spec_devise_helper.rb', 'rb')
  spec_helper = file.read
  File.open('spec/spec_helper.rb', 'w') { |file| file.write(spec_helper) }
else
  file = File.open(File.expand_path(File.join(File.dirname(__FILE__))) +'/spec_helper.rb', 'rb')
  spec_helper = file.read
  File.open('spec/spec_helper.rb', 'w') { |file| file.write(spec_helper) }
end

run 'touch \'.rubocop.yml\''
file = File.open(File.expand_path(File.join(File.dirname(__FILE__))) +'/rubocop.yml', 'rb')
rubocop = file.read
File.open('.rubocop.yml', 'w') { |file| file.write(rubocop) }

rails_command 'haml:erb2haml'

scripts = remove_lines('app/assets/javascripts/application.js', ['turbolinks'])
run 'rm app/assets/javascripts/application.js'
run 'touch \'app/assets/javascripts/application.js\''
File.open('app/assets/javascripts/application.js', 'w') { |file| file.write(scripts) }
