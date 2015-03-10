dir = '/tmp/profitbricks-gem'
pb_user = node['profitbricks']['user'].to_s
pb_password = node['profitbricks']['password'].to_s
if pb_user.empty?
  unless node[:profitbricks].nil?
    pb_user = node[:profitbricks][:user].to_s
    pb_password = node[:profitbricks][:password].to_s
  end
end

unless pb_user.to_s.empty?
  user = node['chef-admin']['user']
  group = node['chef-admin']['group']
  tgz = File.join Chef::Config[:file_cache_path], 'profitbricks-rb.tgz'
  init = <<-INIT
    #!/bin/bash
    set -e
    export HOME=~
    [ -f ~/.bash_profile ] && . ~/.bash_profile
    eval $(chef shell-init bash)
    INIT

  class Chef::Resource
    def gem_installed?(name)
      `chef gem list "#{name}" | grep -q "#{name}"`
      $?.success?
    end
  end


  template '/etc/profile.d/profitbricks.sh' do
    source 'variables.erb'
    variables :vars => {
                  :PROFITBRICKS_USER => pb_user,
                  :PROFITBRICKS_PASSWORD => pb_password
              }
    mode 0755
  end

  remote_file tgz do
    source 'https://github.com/actano/profitbricks-rb/tarball/master'
    not_if { gem_installed? 'profitbricks' }
  end

  directory dir do
    user user
    group group
    mode 0755
    not_if { gem_installed? 'profitbricks' }
  end

  bash 'profitbricks-gem/preinstall' do
    code <<-BUILD
      #{init}
      chef gem install --user-install hoe
      BUILD
    user user
    group group
    environment 'HOME' => Dir.home(user), 'USER' => user, 'USERNAME' => user
    cwd dir
    not_if { gem_installed? 'profitbricks' }
  end

  bash 'profitbricks-gem/build' do
    code <<-BUILD
      #{init}
      tar -zxf "#{tgz}" --strip-components 1
      rm -rf *.gem pkg
      rake gem
      BUILD
    user user
    group group
    environment 'HOME' => Dir.home(user), 'USER' => user, 'USERNAME' => user
    cwd dir
    not_if { gem_installed? 'profitbricks' }
  end

  bash 'profitbricks-gem/install' do
    code <<-INSTALL
      #{init}
      chef gem install --no-user-install pkg/*.gem
      INSTALL
    cwd dir
    not_if { gem_installed? 'profitbricks' }
  end

# TODO GEMS.push 'github:actano/knife-profitbricks'
end