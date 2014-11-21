remote_file "#{Chef::Config[:file_cache_path]}/profitbricks-rb.tgz" do
  source 'https://github.com/actano/profitbricks-rb/tarball/master'
end

bash 'profitbricks-gem' do

end