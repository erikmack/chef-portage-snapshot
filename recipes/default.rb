#
# Cookbook Name:: portage_snapshot
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

settings = node[:portage_snapshot]
portdir = settings[:portdir]
directory portdir do
  owner "root"
  group "root"
  mode 0755
  action :create
end

archive = settings[:archive_filename]
remote_file "/tmp/#{archive}" do
  source "#{settings[:base_url]}/#{archive}"
  action :create_if_missing
end

checksum = "#{archive}.md5sum"
remote_file "/tmp/#{checksum}" do
  source "#{settings[:base_url]}/#{checksum}"
  action :create_if_missing
end

base = settings[:archive_basename]
snaps = settings[:snapshots_dir]
thissnap = "#{snaps}/#{base}"

bash "extract_archive" do
  cwd snaps
  code <<-EOH
  pushd /tmp
  if ! md5sum --check #{checksum}; then
    echo "checksum failed for portage snapshot, failing"
    exit 1
  fi
  popd
  tar xf /tmp/#{archive}
  EOH
  
  # A somewhat arbitrary guard against repeated extraction
  not_if "test -f #{thissnap}/metadata/timestamp"
end

ruby_block "Rename snapshot dir" do
  block do
    ::File.rename("#{snaps}/portage",thissnap)
  end
  only_if "test -d #{snaps}/portage"
end

# If the original system portdir is the
# same as the new portdir, it will be a
# real dir not a symlink.  We'll rename it
# to be .orig
ruby_block "Rename conflicting system portage dir" do
  block do
    ::File.rename(portdir,"#{portdir}.orig")
  end
  only_if "test -d #{portdir}"
  not_if "test -L #{portdir}"
end

# This is symlink from last run of this recipe
link portdir do
  only_if "test -L #{portdir}"
  action :delete
end

link portdir do
  to thissnap
end

portage_make_conf_entry "PORTDIR" do
  value portdir
end
