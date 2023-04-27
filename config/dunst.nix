{ ... }:
{
  config.services.dunst = {
    enable = true;
    settings = {
      global = {
        offset = "6x40";
        frame_width = 2;
        separator_color = "frame";
        highlight = "#ffa666";
        progress_bar_frame_width = 0;
      };
      urgency_low = {
        background = "#2e2e38";
        frame_color = "#c7c7d1";
        foreground = "#c7c7d1";
      };
      urgency_normal = {
        background = "#2e2e38";
        frame_color = "#ffa666";
        foreground = "#c7c7d1";
      };
      urgency_critical = {
        background = "#ffa666";
        frame_color = "#ffa666";
        foreground = "#2e2e38";
      };
    };
  };
}
