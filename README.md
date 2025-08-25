# Generate SSH key
ssh-keygen -t ed25519 -C "email" -f ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

# Test SSH connection
ssh -T git@github.com
