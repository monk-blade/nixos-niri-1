{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ========================================
    # MULTIMEDIA & CAMERA
    # ========================================
    cheese                  # Camera application
    libcamera               # Camera library
    v4l-utils               # Video4Linux utilities
    
    # ========================================
    # AUDIO/VIDEO PLAYERS AND PROCESSING
    # ========================================
    mpv                     # Versatile media player (supports MP3, MP4, etc.)
    vlc                     # VLC media player
    ffmpeg                  # Audio/video processing and conversion
  ];
}
