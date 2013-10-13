settings = default[:portage_snapshot]

settings[:archive_basename] = 'portage-20131009'
settings[:archive_suffix] = ".tar.xz"
settings[:base_url] = 'http://myfiles.example.org' # no trail /

settings[:portdir] = '/usr/portage'
settings[:snapshots_dir] = '/var/portage_snapshots'

settings[:clean_old_snapshots] = true
settings[:keep_n_newest_snapshots] = 3
