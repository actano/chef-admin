cache_root = '/tmp/vagrant-cache'
user = 'vagrant'
group = 'vagrant'

bash 'cache_chefdk' do
  code <<CACHE
set -e
gemdir=$(chef gem env gemdir)
rubyversion=$(basename "${gemdir}")
cachedir="#{cache_root}/gem/${rubyversion}"
mkdir -p "${cachedir}"
chown #{user}:#{group} "#{cache_root}/gem" || echo -n ""
chown #{user}:#{group} "${cachedir}" || echo -n ""
if [ -d "${gemdir}/cache" ]; then
  cp --recursive --no-dereference --preserve=links,timestamps "${gemdir}/cache/" "${cachedir}/"
fi
rm -rf "${gemdir}/cache"
ln -s "${cachedir}" "${gemdir}/cache"
CACHE
  only_if { File.exist? cache_root }
end