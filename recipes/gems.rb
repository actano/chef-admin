node['chef-admin']['gems'].each do |g|
  gem_package g[:name] do
    gem_binary '/opt/chefdk/bin/chef gem'
    options '--no-user-install'
    version g[:version] unless g[:version].nil?
  end
end