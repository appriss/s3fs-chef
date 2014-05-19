
remote_file ::File.join(node[:s3fs][:install_tmp_dir],node[:s3fs][:archive]) do
	source node[:s3fs][:url]
end

bash "extract-archive" do
	cwd node[:s3fs][:install_tmp_dir]
	code <<-EOF
echo '#{node[:s3fs][:archive]}' >>/tmp/debug
tar zxvf #{node[:s3fs][:archive]}
EOF
end

if node[:s3fs][:patches]
	node[:s3fs][:patches].keys.sort.each do |patch|
		remote_file ::File.join(node[:s3fs][:install_tmp_dir],patch) do
			source node[:s3fs][:patches][patch][:source_url]
		end
		bash "apply-patch" do
			cwd ::File.join(node[:s3fs][:install_tmp_dir],"s3fs-#{node[:s3fs][:version]}")
			code "patch -p#{node[:s3fs][:patches][patch][:level]} <#{::File.join(node[:s3fs][:install_tmp_dir],patch)}"
		end
	end
end

bash "build-and-install" do
	cwd ::File.join(node[:s3fs][:install_tmp_dir],"s3fs-#{node[:s3fs][:version]}")
	code <<-EOF
./configure
make
make install
EOF
end