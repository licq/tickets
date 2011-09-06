source 'http://rubygems.org'

gem 'rails', '3.0.9'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'rake'
gem 'sqlite3'
gem 'kaminari' #分页
gem 'mysql2', '0.2.6' #舍弃了mysql驱动，使用mysql2。不过要设置为'< 0.3.0'，0.3版的mysql2是配合rails 3.1的。
gem 'meta_where' #https://github.com/ernie/meta_where 准备移到 https://github.com/ernie/squeel
gem 'meta_search' #https://github.com/ernie/meta_search
gem 'simple_form' #http://doabit.iteye.com/blog/771110
gem 'flutie'  #Basic, default styles for rails applications
gem 'prawn_rails' #pdf
gem 'prawn-format' #pdf
gem 'prawn-layout' #pdf
gem 'spreadsheet' #http://hlee.iteye.com/blog/356510    excel
gem 'excel_rails' #excel
gem 'nokogiri' #https://github.com/tenderlove/nokogiri  'HTML, XML, SAX, and Reader parser'

group :development do
  gem 'jquery-rails'
  gem 'nifty-generators'
  gem 'annotate'  #https://github.com/ctran/annotate_models 'Annotate ActiveRecord models' usage:annotate --exclude tests,fixtures
end
group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
gem "bcrypt-ruby", :require => "bcrypt"
gem "mocha", :group => :test
