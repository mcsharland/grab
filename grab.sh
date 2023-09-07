# Initialize default configurations 
initialize_default_configs() {
  cat <<EOL > "$1"
# Default time limit in minutes
time=3
# Default downloads directory path
downloads_dir=~/Downloads
EOL
}

# Read value from key-value pair in config
read_value_from_file() {
  awk -F '=' -v key="$2" '$1 == key { print $2 }' "$1"
}

grab() {
  # Check for required utilities
  for cmd in awk find mv; do
    if ! command -v $cmd &> /dev/null; then
      echo "Error: $cmd is not installed."
      return 1
    fi
  done

  local all_flag=false
  local list_flag=false
  local permissions_file="$HOME/.grab_config"

  # Init default config
  if [ ! -f "$permissions_file" ]; then
    initialize_default_configs "$permissions_file"
  fi

  # Check if the config file is readable
  if [ ! -r "$permissions_file" ]; then
    echo "Error: Configuration file $permissions_file is not readable."
    return 1
  fi

  # Read and validate config values
  local time_limit=$(read_value_from_file "$permissions_file" "time")
  local default_downloads_dir=$(read_value_from_file "$permissions_file" "downloads_dir")

  if [ -z "$time_limit" ] || [ -z "$default_downloads_dir" ]; then
    echo "Error: Configuration file $permissions_file is malformed. It must contain valid 'time' and 'downloads_dir' keys."
    return 1
  fi

  # Validate time limit
  if ! [[ "$time_limit" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid time limit."
    return 1
  fi
  
  eval default_downloads_dir="$default_downloads_dir"

  local file_count=0

  while getopts "alt:" opt; do
    case $opt in
      a) all_flag=true ;;
      l) list_flag=true ;;
      t) time_limit=$OPTARG ;;
      *) echo "Invalid option."; return 1 ;;
    esac
  done
  shift $((OPTIND - 1))

  local destination_dir=${1:-"."}

  # Check existence & write permissions for destination directory
  if [ ! -d "$destination_dir" ]; then
    echo "Error: Destination directory does not exist."
    return 1
  fi

  if [ ! -w "$destination_dir" ]; then
    echo "Error: You do not have write permissions for $destination_dir."
    return 1
  fi

  if [ "$destination_dir" = "." ]; then
    display_destination="current directory"
  else
    display_destination="$destination_dir"
  fi

  if [ "$all_flag" = true ]; then
    file_count=0
    find "$default_downloads_dir" -maxdepth 1 -type f -mmin "-$time_limit" | while read -r file; do
      mv "$file" "$destination_dir"
      ((file_count++))
      [ "$list_flag" = true ] && echo "Moved: $(basename "$file")"
    done

    [ "$list_flag" = false ] && echo "Moved $file_count files to $display_destination."
  else
    local newest_file=$(find "$default_downloads_dir" -maxdepth 1 -type f -mmin "-$time_limit" -exec ls -lt {} + | head -n 1 | awk '{for(i=9;i<=NF;++i) printf $i (i==NF?ORS:OFS)}')


    if [ -z "$newest_file" ]; then
      echo "No recent files found in Downloads directory within the last $time_limit minutes."
      return 1
    fi

    local newest_file_name=$(basename "$newest_file")
    mv "$newest_file" "$destination_dir"
    echo "Moved $newest_file_name to $display_destination."
  fi
}
