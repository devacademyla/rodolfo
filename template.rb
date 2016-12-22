# Variables
raw_github = 'https://raw.githubusercontent.com/devacademyla/rodolfo/master/'

# Methods
def remove_lines(file, words)
  new_lines = ''
  File.open(file, 'r') do |f|
    f.each_line do |line|
      new_lines << line unless words.any? { |word| line.include? word }
    end
  end
  new_lines
end

def copy_file(file_name, file_copy)
  File.open(file_name, 'wb') do |file|
    if file_copy.respond_to?(:read)
      IO.copy_stream(file_copy, file)
    else
      file.write(file_copy)
    end
  end
end

def update_file(original_file, words)
  new_file = remove_lines(original_file, words)
  run "rm #{original_file}"
  run "touch \'#{original_file}\'"
  File.open(original_file, 'w') { |file| file.write(new_file) }
end

# Questions
add_devise = yes?('Add devise?(yes/no)')
add_yasmine = yes?('Add yasmine?(yes/no)')

# Change Gemfile
update_file('Gemfile', ['sqlite3', 'turbolinks'])

gem 'haml-rails'
gem 'devise' if add_devise
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
  gem 'jasmine' if add_yasmine
end
run 'bundle install'

# OPTIONAL: Add devise
if add_devise
  generate 'devise:install'
  environment 'config.action_mailer.default_url_options = { host: \'localhost\', port: 3000 }', env: 'development'
  class_name = ask('Model name (e.g. User):')
  params = ask('Aditional params (e.g. \'first_name:string last_name:string\'):')
  generate :devise, [class_name, params].join(' ')
  rails_command 'db:migrate'
  spec_file = open(raw_github + 'spec_devise_helper.rb')
else
  spec_file = open(raw_github + 'spec_helper.rb')
end

# Change test to spec
run 'rm -rf test'
generate 'rspec:install'
run 'rm spec/rails_helper.rb'
run 'rm spec/spec_helper.rb'
run 'touch \'spec/spec_helper.rb\''
copy_file('spec/spec_helper', spec_file)

# Update rubocop config
run 'touch \'.rubocop.yml\''
rubocop_file = open(raw_github +'rubocop.yml')
copy_file('.rubocop.yml', rubocop_file)

# Add travis config
run 'touch \'.travis.yml\''
travis_file = open(raw_github +'travis.yml')
copy_file('.travis.yml', travis_file)

# Convert all html files to haml
rails_command 'haml:erb2haml'

# Remove turbolinks from application.js
update_file('app/assets/javascripts/application.js', ['turbolinks'])

# Run eslint config
rails_command 'eslint:print_config'

# OPTIONAL: Run jasmine config
if add_yasmine
  generate 'jasmine:install'
  generate 'jasmine:examples'
  File.open('.travis.yml', 'a') { |file| file.write '- bundle exec rake jasmine:ci' }
end
