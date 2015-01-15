require 'serverspec'

# Required by serverspec
set :backend, :exec
set :path, '/opt/rbenv/bin:/opt/rbenv/shims:$PATH'

RSpec.configure do |c|
  user    = 'vagrant'
end

describe command('rbenv global') do
  its(:stdout) { should match '2.1.1' }
end