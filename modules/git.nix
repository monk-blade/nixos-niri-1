{ config, lib, pkgs, ... }:

let
  # Check if secrets exist in home directory
  secretsPath = "${config.home.homeDirectory}/.nixos-secrets";
  hasSecrets = builtins.pathExists secretsPath;
  
  # Load secrets if they exist
  secrets = if hasSecrets 
    then import secretsPath
    else {
      githubUser = "abbesm0hamed";
      githubEmail = "abbesmohamed717@gmail.com";
      gpgKey = null;
    };
in
{
  programs.git = {
    enable = true;
    userName = secrets.githubUser;
    userEmail = secrets.githubEmail;
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
      
      # GitHub CLI integration
      credential.helper = "store";
      
      # Better diff and merge
      diff.algorithm = "patience";
      merge.conflictstyle = "diff3";
    };
    
    # GPG signing (only if key exists)
    signing = lib.mkIf (secrets.gpgKey != null) {
      key = secrets.gpgKey;
      signByDefault = true;
    };
  };
  
  # SSH configuration for GitHub
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/github_rsa";
      };
    };
  };
  
  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
    };
  };
}
