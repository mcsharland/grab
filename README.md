# grab
grabs recently downloaded files and moves them to the current working directory

## Installation

### Option 1: As a Standalone Script

1. **Download the Script**: Save the `grab` function and its helper functions into a file, say `grab.sh`.

2. **Make it Executable**: Run `chmod +x grab.sh` to make the script executable.

3. **Move to Bin Directory**: Optionally, you can move the script to a directory in your `PATH` to make it accessible from anywhere. For example:

    ```bash
    mv grab.sh /usr/local/bin/grab
    ```

### Option 2: Sourcing in Shell Configuration

If you prefer to have `grab` as a shell function:

1. **Download the Script**: Save the `grab` function and its helper functions into a file, say `grab-function.sh`.

2. **Source in Shell Configuration**: Add the following line to your `.bashrc`, `.zshrc`, or equivalent:

    ```bash
    source /path/to/grab-function.sh
    ```

3. **Reload your Shell Configuration**: To apply the changes:

    ```bash
    source ~/.bashrc  # For Bash users
    source ~/.zshrc   # For Zsh users
    ```

## Usage

```bash
grab [OPTIONS] [DESTINATION_DIR]
```

### Options

- `-a`: Move all eligible files from the Downloads directory.
- `-l`: List files as they are moved.
- `-t TIME_LIMIT`: Specify a time limit (in minutes) for which to consider files from the Downloads directory.

### Configuration File

The function reads default settings from a configuration file located at `$HOME/.grab_config`. The configuration file contains key-value pairs for the default time limit and the default Downloads directory.

Example content:

```text
# Default time limit in minutes
time=3
# Default downloads directory path
downloads_dir=~/Downloads
```

## Examples

1. Move the most recently downloaded file to the current directory:

    ```bash
    grab
    ```

2. Move all files downloaded in the last 5 minutes to a directory named `target`:

    ```bash
    grab -a -t 5 target
    ```

3. Move all files downloaded in the last 3 minutes to the current directory and list them:

    ```bash
    grab -a -l
    ```
