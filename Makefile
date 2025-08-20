# NixOS Flakes Management Makefile
# Usage: make <target>

.PHONY: help build switch boot test update upgrade clean check format lint

# Default target
help:
	@echo "NixOS Flakes Management Commands:"
	@echo ""
	@echo "Build Commands:"
	@echo "  build        - Build system configuration"
	@echo "  build-min    - Build minimal configuration"
	@echo ""
	@echo "System Commands:"
	@echo "  switch       - Build and switch to system configuration"
	@echo "  boot         - Build and set as next boot"
	@echo "  test         - Test system configuration (temporary)"
	@echo "  switch-min   - Switch to minimal configuration"
	@echo ""
	@echo "Home Manager Commands (Fast):"
	@echo "  home-switch        - Switch home-manager configuration (packages only)"
	@echo "  home-build         - Build home-manager configuration"
	@echo "  home-test          - Test home-manager configuration (dry-run)"
	@echo "  home-nix           - Build home-manager with nix (alternative)"
	@echo "  home-activate      - Build and activate home-manager (alternative)"
	@echo ""
	@echo "Maintenance Commands:"
	@echo "  update             - Update flake inputs"
	@echo "  upgrade            - Update and rebuild system"
	@echo "  clean              - Clean old generations and garbage collect"
	@echo "  check              - Check flake for errors"
	@echo "  format             - Format Nix files with nixpkgs-fmt"
	@echo ""
	@echo "Git Commands:"
	@echo "  commit             - Add, commit and push changes"
	@echo ""

# Build configurations
build:
	@echo "Building system configuration..."
	sudo nixos-rebuild build --flake .#abbes

build-min:
	@echo "Building minimal configuration..."
	sudo nixos-rebuild build --flake .#minimal

# Switch configurations
switch:
	@echo "Switching to system configuration..."
	sudo nixos-rebuild switch --flake .#abbes

switch-min:
	@echo "Switching to minimal configuration..."
	sudo nixos-rebuild switch --flake .#minimal

# Boot configurations
boot:
	@echo "Setting as next boot configuration..."
	sudo nixos-rebuild boot --flake .#abbes

boot-min:
	@echo "Setting minimal as next boot configuration..."
	sudo nixos-rebuild boot --flake .#minimal

# Test configurations (temporary, reverts on reboot)
test:
	@echo "Testing system configuration (temporary)..."
	sudo nixos-rebuild test --flake .#abbes

test-min:
	@echo "Testing minimal configuration (temporary)..."
	sudo nixos-rebuild test --flake .#minimal

# Home Manager Commands
home-switch:
	@echo "Switching home-manager configuration (fast)..."
	home-manager switch --flake .#abbes

home-build:
	@echo "Building home-manager configuration..."
	home-manager build --flake .#abbes

home-test:
	@echo "Testing home-manager configuration..."
	home-manager switch --flake .#abbes --dry-run

# Alternative home-manager commands (work without home-manager command)
home-nix:
	@echo "Building home-manager with nix..."
	nix build .#homeConfigurations.abbes.activationPackage

home-activate:
	@echo "Activating home-manager configuration..."
	nix build .#homeConfigurations.abbes.activationPackage && ./result/activate

# Maintenance
update:
	@echo "Updating flake inputs..."
	nix flake update

upgrade: update switch
	@echo "System upgraded successfully!"

clean:
	@echo "Cleaning old generations and garbage collecting..."
	sudo nix-collect-garbage -d
	sudo nixos-rebuild switch --flake .#abbes
	@echo "Cleanup completed!"

check:
	@echo "Checking flake for errors..."
	nix flake check

format:
	@echo "Formatting Nix files..."
	find . -name "*.nix" -exec nixpkgs-fmt {} \;

# Development helpers
lint:
	@echo "Linting Nix files..."
	find . -name "*.nix" -exec statix check {} \;

# Git workflow
commit:
	@echo "Committing changes..."
	@read -p "Enter commit message: " msg; \
	git add . && \
	git commit -m "$$msg" && \
	git push origin main

# Show system info
info:
	@echo "System Information:"
	@echo "Current generation: $$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1)"
	@echo "Flake inputs:"
	@nix flake metadata

# Emergency rollback
rollback:
	@echo "Rolling back to previous generation..."
	sudo nixos-rebuild switch --rollback

# Convenient aliases
s: switch
b: build
t: test
u: update
c: clean
h: home-switch
hb: home-build
ht: home-test
hn: home-nix
ha: home-activate

# Quick commands for development
quick-home: home-switch
	@echo "Home configuration updated! Restart applications if needed."

quick-system: switch
	@echo "System configuration updated!"
