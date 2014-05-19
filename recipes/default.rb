
remote_file ::File.join(node[:s3fs][:install_tmp_dir],node[:s3fs][:archive]) do
	source node[:s3fs][:url]
end

bash "extract-archive" do
	cwd node[:s3fs][:install_tmp_dir]
	command <<-EOF
tar zxvf #{node[:s3fs][:archive]}
EOF
end

node[:s3fs][:patches].keys.sort.each do |patch|
	remote_file ::File.join(node[:s3fs][:install_tmp_dir],patch) do
		source node[:s3fs][:patches][patch][:source_url]
	end
	bash "apply-patch" do
		cwd ::File.join(node[:s3fs][:install_tmp_dir],"s3fs-#{node[:s3fs][:version]}")
		command "patch -p#{node[:s3fs][:patches][patch][:level]} <#{::File.join(node[:s3fs][:install_tmp_dir]),patch}"
	end
end

bash "build-and-install" do
	cwd ::File.join(node[:s3fs][:install_tmp_dir],"s3fs-#{node[:s3fs][:version]}")
	command <<-EOF
./configure
make
make install
EOF
end