# tmux-net-speed
Tmux plugin to monitor download and upload speed of all network interfaces

## Usage

Add one of the following format string to `status-left` (or `status-right`)
tmux option.

- `#{download_speed}` - Shows only download speed
- `#{upload_speed}` - Shows only upload speed
- `#{net_speed}` - Shows both the upload and download speeds.
  Example: "⇣  1.23 MB/s ⇡ 2.5 MB/s"

NOTE: Shows value in either MB/s, KB/s or B/s.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'tmux-plugins/tmux-net-speed'

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-left`, they should now be visible.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-net-speed ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/net_speed.tmux

Reload TMUX environment:

    $ tmux source-file ~/.tmux.conf

If format strings are added to `status-right`, they should now be visible.


### Storage of Past Values
This plugin stores the total output for all the interfaces in a file in `/tmp`.
Therefore, the current user must be able to write and read from that directory.


### TODO
- Add error handling
- Configure format string for `#{net_speed}`
- Handle other OSs (currently only supports Linux)


### Contributors
- [beeryardtech](https://github.com/beeryardtech)
- [edouard-lopez](https://github.com/edouard-lopez)
- [aramboi](https://github.com/aramboi)
- [kenanpelit](https://github.com/kenanpelit)


### License

[MIT](LICENSE)
