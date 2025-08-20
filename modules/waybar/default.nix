{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 22;
        
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "" ];
        modules-right = [
          "niri/language"
          "wireplumber"
          "wireplumber#microphone"
          "backlight"
          "battery"
          "custom/weather"
          "custom/prayer"
          "custom/notification"
          "clock"
          "custom/power"
          "tray"
        ];

        # Niri Workspaces
        "niri/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        # Network
        network = {
          format-wifi = "󰤨 {bandwidthUpBytes} 󰤥 {bandwidthDownBytes}";
          format-ethernet = "󰈀 {bandwidthUpBytes} 󰤥 {bandwidthDownBytes}";
          format-disconnected = "󰤭 Disconnected";
          interval = 2;
          tooltip-format = "{ifname}: {ipaddr}";
        };

        # Memory
        memory = {
          format = "󰍛 {percentage}%";
          interval = 5;
        };

        # CPU
        cpu = {
          format = "󰻠 {usage}%";
          interval = 5;
        };

        # Wireplumber (Audio)
        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡏";
            headset = "󰋎";
            phone = "󰄜";
            portable = "󰦧";
            car = "󰄋";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        # Microphone
        "wireplumber#microphone" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        # Backlight
        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
        };

        # Battery
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-charging = "󰂄 {capacity}%";
          interval = 30;
          states = {
            warning = 25;
            critical = 10;
          };
        };

        # Night Mode (commented out)
        "custom/night_mode" = {
          format = "{}";
          exec = "echo '󱩌' NL";
          on-click = "wlsunset -t 4500 -T 6500";
          on-click-right = "pkill wlsunset";
          tooltip = false;
        };

        # Disk
        disk = {
          format = "󰋊 {percentage_free}%";
          path = "/";
        };

        # Custom Weather
        "custom/weather" = {
          format = "{}";
          exec = "~/.config/waybar/scripts/weather.sh";
          interval = 1800; # Update every 30 minutes
          return-type = "json";
          tooltip = true;
        };

        # Custom Prayer Times
        "custom/prayer" = {
          format = "🕌 {}";
          exec = "~/.config/waybar/scripts/next-prayer.sh";
          interval = 60; # Update every minute
          tooltip = false;
        };

        # Custom Notification (Mako)
        "custom/notification" = {
          format = "🔔 {}";
          exec = "~/.config/waybar/scripts/notification.sh";
          interval = 30; # Update every 5 seconds
          return-type = "json";
          tooltip = true;
          on-click = "makoctl invoke";
          on-click-right = "makoctl dismiss --all";
        };

        # Custom Power Menu
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };

        # Language
        "niri/language" = {
          format = "󰌓 {}";
        };

        # Clock
        clock = {
          format = "{:%d, %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
        };

        # System Tray
        tray = {
          icon-size = 20;
          spacing = 12;
        };
      };
    };

    # CSS Styling - Reference external file for better modularity
    style = builtins.readFile ./style.css;
  };

  # Create the necessary script files by referencing external scripts
  home.file.".config/waybar/scripts/weather.sh" = {
    source = ./scripts/weather.sh;
    executable = true;
  };

  home.file.".config/waybar/scripts/next-prayer.sh" = {
    source = ./scripts/next-prayer.sh;
    executable = true;
  };

  home.file.".config/waybar/scripts/mako-count.sh" = {
    source = ./scripts/mako-count.sh;
    executable = true;
  };



  # Ensure required packages are available
  home.packages = with pkgs; [
    # Fonts for proper icon display
    nerd-fonts.space-mono
    nerd-fonts.victor-mono
    
    # Utilities used by the scripts
    pavucontrol # for audio control
    wlogout # for power menu
    jq # for JSON parsing in scripts
    
    # Optional: for sunset/sunrise
    wlsunset
  ];
}