portage_snapshot Cookbook
=========================
Install a remote portage snapshot.

Gentoo, more than other distros, makes it easy to have a "frozen
repository" of packages.  This is important in the data center, when
it's important that your server deployments are deterministic - in
other words, the same system can be built a month from now that you
built today.  We're adjusting this "rolling release" distro into
one that rolls at an appropriate tempo for your business.

This cookbook downloads a portage snapshot tarball with checksum,
confirms the checksum, extracts the archive (maybe deleting your old
portage tree first), and sets the PORTDIR value in make.conf.

It is up to you to pre-place an archive/checksum where they can be
downloaded over HTTP (e.g. CloudFiles or standard web hosting).  You
could link directly to a Gentoo mirror (the configured default), but
snapshots only remain at a mirror for a week, which probably isn't
adequate for your needs.

Note that the recipe deletes the PORTDIR entirely before extracting a
new one.  This has the effect of deleting DISTDIR and PKGDIR, which by
default are under PORTDIR, and this may in fact be a nice way to keep
the disk from filling with distfiles.  However, if you use PKGDIR, or
if don't want your distfiles cache to be purged, consider moving your
DISTDIR and/or PKGDIR to a location outside of PORTDIR.

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
