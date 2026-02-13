# grab

Move recently downloaded files to your current directory.

## Install

```bash
chmod +x grab.py
sudo mv grab.py /usr/local/bin/grab
```

Requires Python 3. No dependencies.

## Usage

```bash
grab                    # move newest downloaded file here
grab -a                 # move all recent files here
grab -a -t 5 target/    # move files from last 5 minutes to target/
grab -x                 # delete newest downloaded file
grab -l                 # list recent files without moving
grab -t -1              # ignore time limit, grab newest file
```

## Options

| Flag   | Description                                         |
| ------ | --------------------------------------------------- |
| `-a`   | All matching files (default: newest only)           |
| `-x`   | Delete instead of move                              |
| `-l`   | List matches without acting                         |
| `-t N` | Time limit in minutes (default: 3, -1 for no limit) |

## Config

Auto-created at `~/.config/grab/grab_config`:

```
time=3
downloads_dir=~/Downloads
```
