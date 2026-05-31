{ ... }:
{
  programs.starship = {
    enable = true;
    # Custom settings (optional)
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };
}
