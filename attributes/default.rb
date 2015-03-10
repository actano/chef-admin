default['chef-admin'].tap do |admin|
  admin['user'] = 'vagrant'
  # admin[:id_rsa] = ''
  admin['bash_login'] = []
  admin['gems'] = []
  admin['knife-settings'] = []
  admin['bootstrap_version'] = '11.16.4'
end

default['chef_dk']['version'] = '0.3.5'
default['profitbricks']['user'] = ''