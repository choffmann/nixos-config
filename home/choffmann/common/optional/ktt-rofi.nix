{
  pkgs,
  inputs,
  ...
}:
let
  ktt = inputs.ktt.packages.${pkgs.stdenv.hostPlatform.system}.default;

  kttRofi = pkgs.writeShellApplication {
    name = "ktt-rofi";
    runtimeInputs = [
      ktt
      pkgs.rofi
      pkgs.jq
      pkgs.libnotify
    ];
    text = ''
      get_status() {
        ktt --json status 2>/dev/null
      }

      get_projects() {
        ktt projects --json 2>/dev/null
      }

      format_elapsed() {
        local secs=$1
        printf "%02d:%02d:%02d" $((secs / 3600)) $(( (secs % 3600) / 60 )) $((secs % 60))
      }

      build_target() {
        local json="$1"
        echo "$json" | jq -r '[.customer, .project, .activity] | map(select(. != null and . != "")) | join("/")'
      }

      notify() {
        notify-send -t 3000 "ktt" "$1"
      }

      notify_error() {
        notify-send -u critical -t 5000 "ktt" "$1"
      }

      do_stop() {
        local status="$1"
        local target elapsed_secs elapsed current_desc desc

        target=$(build_target "$status")
        elapsed_secs=$(echo "$status" | jq -r '.elapsed_seconds // 0')
        elapsed=$(format_elapsed "$elapsed_secs")
        current_desc=$(echo "$status" | jq -r '.description // ""')

        desc=$(rofi -dmenu -p "Stop timer" \
          -mesg "Stopping: $target ($elapsed)" \
          -filter "$current_desc" \
          -theme-str 'listview { lines: 0; }') || return 1

        if [ -n "$desc" ]; then
          ktt stop -d "$desc" 2>/dev/null || { notify_error "Failed to stop timer"; return 1; }
        else
          ktt stop 2>/dev/null || { notify_error "Failed to stop timer"; return 1; }
        fi

        notify "Stopped: $target ($elapsed)"
      }

      do_start() {
        local projects_json customer_line customer project_line project activity desc selected

        projects_json=$(get_projects) || { notify_error "Failed to get projects"; return 1; }

        # Step 1: Select customer (alias - name)
        customer_line=$(echo "$projects_json" \
          | jq -r '.customers[] | "\(.alias) - \(.name)"' \
          | rofi -dmenu -p "Customer" -i) || return 1
        [ -z "$customer_line" ] && return 1
        customer=$(echo "$customer_line" | cut -d' ' -f1)

        # Step 2: Select project (alias - name)
        project_line=$(echo "$projects_json" \
          | jq -r --arg c "$customer" '.customers[] | select(.alias == $c) | .projects[] | "\(.alias) - \(.name)"' \
          | rofi -dmenu -p "Project" -i -mesg "$customer_line") || return 1
        [ -z "$project_line" ] && return 1
        project=$(echo "$project_line" | cut -d' ' -f1)

        # Step 3: Activity (freeform, optional)
        activity=$(rofi -dmenu -p "Activity (optional)" \
          -mesg "$customer_line / $project_line" \
          -theme-str 'listview { lines: 0; }') || true

        if [ -n "$activity" ]; then
          selected="$customer/$project/$activity"
        else
          selected="$customer/$project"
        fi

        # Step 4: Description (optional)
        desc=$(rofi -dmenu -p "Description (optional)" \
          -mesg "Target: $selected" \
          -theme-str 'listview { lines: 0; }') || true

        # Step 5: Start timer
        if [ -n "$desc" ]; then
          ktt start "$selected" -d "$desc" 2>/dev/null || { notify_error "Failed to start timer"; return 1; }
        else
          ktt start "$selected" 2>/dev/null || { notify_error "Failed to start timer"; return 1; }
        fi

        notify "Started: $selected"
      }

      # Quick stop shortcut
      if [ "''${1:-}" = "stop" ]; then
        status=$(get_status) || { notify_error "Failed to get ktt status"; exit 1; }
        is_running=$(echo "$status" | jq -r '.running')

        if [ "$is_running" != "true" ]; then
          notify "No timer running"
          exit 0
        fi

        do_stop "$status"
        exit 0
      fi

      # Main unified interface
      status=$(get_status) || { notify_error "Failed to get ktt status"; exit 1; }
      is_running=$(echo "$status" | jq -r '.running')

      if [ "$is_running" = "true" ]; then
        target=$(build_target "$status")
        elapsed_secs=$(echo "$status" | jq -r '.elapsed_seconds // 0')
        elapsed=$(format_elapsed "$elapsed_secs")
        desc=$(echo "$status" | jq -r '.description // ""')

        mesg="Running: $target ($elapsed)"
        if [ -n "$desc" ]; then
          mesg=$(printf "%s\n%s" "$mesg" "$desc")
        fi

        choice=$(printf "Stop timer\nStart new timer" | rofi -dmenu -p "ktt" -mesg "$mesg" -i) || exit 0
      else
        choice=$(printf "Start timer" | rofi -dmenu -p "ktt" -mesg "No timer running" -i) || exit 0
      fi

      case "$choice" in
        "Stop timer")
          do_stop "$status"
          ;;
        "Start new timer")
          do_stop "$status" || exit 1
          do_start
          ;;
        "Start timer")
          do_start
          ;;
        *)
          exit 0
          ;;
      esac
    '';
  };
in
{
  # niri binds spawn "ktt-rofi" by name, so it has to be on PATH.
  home.packages = [
    ktt
    kttRofi
  ];
}
