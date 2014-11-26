node['chef-admin']['gems'].each do |g|
  gem_package g do
    gem_binary '/opt/chefdk/bin/chef gem'
    options '--no-user-install'
  end
end