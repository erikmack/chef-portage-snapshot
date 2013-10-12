#
# Cookbook Name:: portage_snapshot
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Remove dir entirely so we don't extract different
# tarballs to the same place.  This can blow away your
# distfiles if you have it configured under this dir.
# Consider moving your distfiles dir for better caching.
directory node[:portage_snapshot][:portdir] do
  recursive true
  action :delete
end

directory node[:portage_snapshot][:portdir] do
  owner "root"
  group "root"
  mode 0755
  action :create
end

# :create_if_missing is good for dated snapshots like 
# portage-20131009.tar.xz.  For the default value 
remote_file "/tmp/#{node[:portage_snapshot][:archive_filename]}" do
  source "#{node[:portage_snapshot][:base_url]}/#{node[:portage_snapshot][:archive_filename]}"
  action node[:portage_snapshot][:download_action]
end

remote_file "/tmp/#{node[:portage_snapshot][:checksum_filename]}" do
  source "#{node[:portage_snapshot][:base_url]}/#{node[:portage_snapshot][:checksum_filename]}"
  action node[:portage_snapshot][:download_action]
end

bash "extract_archive" do
  cwd node[:portage_snapshot][:portdir]
  code <<-EOH
  pushd /tmp
  if ! md5sum --check #{node[:portage_snapshot][:checksum_filename]}; then
    echo "checksum failed for portage snapshot, failing"
    exit 1
  fi
  popd
  cd .. # archives contains dir 'portage' already
  tar xf /tmp/#{node[:portage_snapshot][:archive_filename]}
  EOH
end

portage_make_conf_entry "PORTDIR" do
  value node[:portage_snapshot][:portdir]
end
