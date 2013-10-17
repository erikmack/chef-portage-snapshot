#
# Cookbook Name:: portage_snapshot
# Recipe:: default
#
# Copyright (C) 2013 Erik Mackdanz

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

settings = node[:portage_snapshot]

portdir = settings[:portdir]
base = settings[:archive_basename]
snaps = settings[:snapshots_dir]
thissnap = "#{snaps}/#{base}"

directory thissnap do
  action :create
  recursive true
  owner "root"
  group "root"
end

archive = "#{base}#{settings[:archive_suffix]}"
baseurl = settings[:base_url]
remote_file "#{thissnap}/#{archive}" do
  source "#{baseurl}/#{archive}"
  action :create_if_missing
end

checksum = "#{archive}.md5sum"
remote_file "#{thissnap}/#{checksum}" do
  source "#{baseurl}/#{checksum}"
  action :create_if_missing
end

bash "extract_archive" do
  cwd thissnap
  code <<-EOH
  if ! md5sum --check #{checksum}; then
    echo "checksum failed for portage snapshot, deleting corrupted artifacts and failing"
    rm -rf *
    exit 1
  fi
  tar xf #{archive}
  EOH
  
  # A somewhat arbitrary guard against repeated extraction
  not_if "test -f #{thissnap}/portage/metadata/timestamp"
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
  to "#{thissnap}/portage"
end

portage_make_conf_entry "PORTDIR" do
  value portdir
end

bash 'clean_old_snapshots' do
  cwd snaps
  code <<-EOH
  rm -rf $(ls | head -n -#{settings[:keep_n_newest_snapshots]} | grep -v #{base})
  EOH
  only_if {settings[:clean_old_snapshots]}
end
