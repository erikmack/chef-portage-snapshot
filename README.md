portage_snapshot Cookbook
=========================
Install a portage snapshot from a remote HTTP server.

Gentoo, more than other distros, makes it easy to have a "frozen
repository" of packages.  This is important in the data center, when
you want some guarantee that your server deployments are deterministic
- in other words, the same system can be built a month from now that
you built today.  We're adjusting Gentoo's "rolling release"
capability so that it rolls at an appropriate tempo for your business.
You want to give up "emerge --sync" on these systems.

This cookbook:
1. downloads a portage snapshot tarball with checksum
1. confirms the checksum
1. extracts the archive to a directory that can hold multiple snapshots
1. maybe backs up your original system PORTDIR
1. symlinks your PORTDIR to the latest snapshot
1. sets the PORTDIR value in make.conf

The symlink setup maximizes the resilience of the cookbook and also
makes it easy to roll back to an old snapshot if the new one makes
problems.

It is up to you to pre-place an archive/checksum where they can be
downloaded over HTTP (e.g. CloudFiles or standard web hosting).  You
mustn't link directly to a Gentoo mirror because snapshots are only
mirrored for a week.

Note that if your DISTDIR and PKGDIR are under PORTDIR, then the
symlink change will orphan those old files.  This can be a natural way
to keep old stuff from accumulating.  If you're not okay with this,
just change your DISTDIR and PKGDIR to be outside of PORTDIR.  A
future enhancement will allow deleting all snapshots except the newest
N snapshots, so the disk won't fill over time.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - portage_snapshot needs toaster to brown your bagel.

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### portage_snapshot::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['portage_snapshot']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### portage_snapshot::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `portage_snapshot` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[portage_snapshot]"
  ]
}
```

Todo
----
- Recipe deletes all snapshots except the n newest
- Check gpg signature (can be disabled)
- Allow disabling checksum

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
