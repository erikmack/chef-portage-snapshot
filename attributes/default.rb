settings = default[:portage_snapshot]

base = settings[:archive_basename] = 'portage-20131009'
settings[:archive_suffix] = ".tar.xz"
settings[:base_url] = 'http://gentoo.mirrors.pair.com/snapshots' # no trail /

settings[:portdir] = '/usr/portage'
settings[:snapshots_dir] = '/var/portage_snapshots'

