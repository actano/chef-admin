user = node['chef-admin']['user']
group = node['chef-admin']['group']

template File.join Dir.home(user), '.bash_login' do
  source 'bash_login.erb'
  variables :bash_login => node['chef-admin']['bash_login']
  user user
  group group
  mode 0700
end