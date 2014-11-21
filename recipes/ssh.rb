user = node['chef-admin']['user']
group = node['chef-admin']['group']
home = Dir.home(user)
ssh_dir = File.join home, '.ssh'
pkey = node['chef-admin']['id_rsa']
pkey_file = File.join ssh_dir, 'id_rsa'

directory ssh_dir do
  user user
  group group
  mode 0700
  not_if { pkey.to_s.empty? }
end

file pkey_file do
  content pkey
  user user
  group group
  mode 0600
  backup false
  sensitive true
  not_if { pkey.to_s.empty? }
end

file File.join ssh_dir, 'id_rsa.pub' do
  content lazy { %x[ openssl rsa -in #{pkey_file} -pubout 2> /dev/null ] }
  user user
  group group
  mode 0644
  only_if { File.exist? pkey_file }
end