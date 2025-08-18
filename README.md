# Generate SSH key
ssh-keygen -t ed25519 -C "abbesmohamed717@gmail.com" -f ~/.ssh/github
cat ~/.ssh/github.pub

# Test SSH connection
ssh -T git@github.com
