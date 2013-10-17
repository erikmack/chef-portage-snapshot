portage_snapshot Cookbook
=========================
Install a portage snapshot from a remote HTTP server.

Gentoo, more than other distros, makes it easy to have a "frozen
repository" of packages.  This is important in the data center, when
you want some guarantee that your server deployments are deterministic.
In other words, the same system can be built a month from now that
you built today.  We're adjusting Gentoo's "rolling release"
capability so that it rolls at an appropriate tempo for your business.

You will no longer "emerge --sync" on these systems.

This cookbook:

1. downloads a portage snapshot tarball with checksum
1. confirms the checksum
1. extracts the archive to a directory that can hold multiple snapshots
1. maybe backs up your original system PORTDIR (if the location conflicts)
1. symlinks your PORTDIR to the latest snapshot
1. sets the PORTDIR value in make.conf

The symlink setup maximizes the resilience of the cookbook and also
makes it easy to roll back to an old snapshot if the new one makes
problems.

It is up to you to pre-place an archive/checksum where they can be
downloaded over HTTP (e.g. CloudFiles, CloudFront, standard web hosting).  
Though it's possible (and useful for testing), you
mustn't link directly to a Gentoo mirror because snapshots are only
mirrored for a week.

Note that if your DISTDIR and PKGDIR are under PORTDIR, then the
symlink change will orphan those old files, and the cleaning feature (below) may 
eventually delete them.  This can be a natural way
to keep old stuff from accumulating unboundedly.  If you're not okay with this,
just change your DISTDIR and PKGDIR to be outside of PORTDIR. 

A cleaning feature, enabled by default, deletes all but the newest
three snapshots.  This keeps the recipe from filling your disk over
time with snapshots.  At this time, "newest" is determined by sorting
the directories under the snapshots directory and taking the latest
ones, which requires that your basename is in a date-sortable format
(e.g.  portage-20131009) like Gentoo publishes them.

Requirements
------------
portage_snapshot requires the portage cookbook by Vasily Mikhaylichenko
https://github.com/lxmx/chef-portage.

Attributes
----------
#### portage_snapshot::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['portage_snapshot'][:archive_basename]</tt></td>
    <td>String</td>
    <td>The date-sortable snapshot name.</td>
    <td><tt>'portage-20131009'</tt></td>
  </tr>
  <tr>
    <td><tt>['portage_snapshot'][:archive_suffix]</tt></td>
    <td>String</td>
    <td>archive_basename + archive_suffix = short file name</td>
    <td><tt>'.tar.xz'</tt></td>
  </tr>
  <tr>
    <td><tt>['portage_snapshot'][:base_url]</tt></td>
    <td>String</td>
    <td>Where to download the snapshot, excluding the /filename</td>
    <td><tt>'http://myfiles.example.org'</tt></td>
  </tr>
  <tr>
    <td><tt>['portage_snapshot'][:portdir]</tt></td>
    <td>String</td>
    <td>The filesystem location where the portage tree should live</td>
    <td><tt>'/usr/portage'</tt></td>
  </tr>
  <tr>
    <td><tt>['portage_snapshot'][:snapshots_dir]</tt></td>
    <td>String</td>
    <td>A place to keep snapshots</td>
    <td><tt>'/var/portage_snapshots'</tt></td>
  </tr>
  <tr>
    <td><tt>['portage_snapshot'][:clean_old_snapshots]</tt></td>
    <td>Boolean</td>
    <td>Whether to delete old snapshots to set an upper bound on disk usage</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['portage_snapshot'][:keep_n_newest_snapshots]</tt></td>
    <td>Integer</td>
    <td>How many snapshots to keep if :clean_old_snapshots is true</td>
    <td><tt>3</tt></td>
  </tr>
</table>

Usage
-----
#### portage_snapshot::default
Include `portage_snapshot` in your node's `run_list`, and
specify the URL and snapshot basename for the download.

```json
{
  "name":"my_node",
  "normal" : {
    "portage_snapshot" : {
      "base_url" : "http://mycdn.example.org/foobucket",
      "archive_basename" : "portage-20131009"
    }
  },
  "run_list": [
    "recipe[portage_snapshot]"
  ]
}
```

Todo
----
- Cleaning check could determine "newest" snapshots from first 
  field in metadata/timestamp.x instead of sorting dir names.
  Use a ruby block for this not bash
- Check gpg signature (can be disabled)
- Allow disabling checksum download/check

Contributing
------------
Pull requests, patches, issues, e-mails welcome.

License and Authors
-------------------
Affero GPL v3

Erik Mackdanz
