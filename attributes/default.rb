
archive = 'portage-latest.tar.xz'
default[:portage_snapshot][:portdir] = '/usr/portage'
default[:portage_snapshot][:archive_filename] = archive
default[:portage_snapshot][:checksum_filename] = "#{archive}.md5sum"
default[:portage_snapshot][:base_url] = 'http://gentoo.mirrors.pair.com/snapshots' # no trail /

# :create is okay for portage-latest.tar.xz.  Override to
# :create_if_missing for dated snapshots (e.g. portage-20131009.tar.xz)
# so that subsequent chef-client runs can re-use a previously downloaded file.
default[:portage_snapshot][:download_action] = :create

