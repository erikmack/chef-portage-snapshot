#
# Cookbook Name:: portage_snapshot
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

settings = default[:portage_snapshot]

settings[:archive_basename] = 'portage-20131009'
settings[:archive_suffix] = ".tar.xz"
settings[:base_url] = 'http://myfiles.example.org' # no trail /

settings[:portdir] = '/usr/portage'
settings[:snapshots_dir] = '/var/portage_snapshots'

settings[:clean_old_snapshots] = true
settings[:keep_n_newest_snapshots] = 3
