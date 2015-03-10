user = node['chef-admin']['user']
group = node['chef-admin']['group']
home = Dir.home(user)
chef_dir = File.join home, '.chef'

directory chef_dir do
  user user
  group group
  mode 0700
end

class Chef::Resource::Template
  def knife_settings
    settings = node['chef-admin']['knife-settings']
    settings = settings.nil? ? {} : Hash.new(settings)
    settings[:bootstrap_version] = node['chef-admin']['bootstrap_version'].to_s
  end
end

template File.join(chef_dir, 'knife-solo.rb') do
  source 'knife_rb.erb'
  variables lazy {
              settings = knife_settings
              settings[:solo] = true
              { :vars => settings, :user => user, :head => {}}
            }
  user user
  group group
  mode 0600
end

template File.join(chef_dir, 'knife.rb') do
  source 'knife_rb.erb'
  variables lazy {
              settings = knife_settings
              head = {
                  :client_key => File.join(chef_dir, 'admin.pem'),
                  :validation_key => File.join(chef_dir, 'chef-validator.pem'),
                  :chef_server_url => node['chef-admin']['chef-server-url'].to_s,
                  :chef_version => node['chef-admin']['chef-version'].to_s
              }
              { :head => head, :vars => settings, :user => user }
            }
  user user
  group group
  mode 0600
end
