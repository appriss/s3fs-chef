default[:s3fs][:install_tmp_dir] = "/var/tmp/"
default[:s3fs][:prefix] = "/usr/local"
default[:s3fs][:version] = "1.7.1"
default[:s3fs][:archive] = "s3fs-#{node[:s3fs][:version]}.tar.gz"
default[:s3fs][:url] = "https://s3fs.googlecode.com/files/#{node[:s3fs][:archive]}"
default[:s3fs][:patches] = nil
