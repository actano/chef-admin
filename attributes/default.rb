default['chef-admin'].tap do |admin|
  admin['user'] = 'vagrant'
  # admin[:id_rsa] = ''
  admin['bash_login'] = []
  admin['gems'] = [
    {:name => 'knife-solo'},
    {:name => 'librarian-chef'}
  ]
  admin['knife_rb_settings'] = []
end

default['chef_dk']['version'] = '0.3.5'
