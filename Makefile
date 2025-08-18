# NixOS Flakes Management Makefile
# Usage: make <target>

.PHONY: help build switch boot test update upgrade clean check format lint

# Default target
help:
	@echo "NixOS Flakes Management Commands:"
	@echo ""
	@echo "Build Commands:"
	@echo "  build-abbes  - Build abbes configuration"
	@echo ""
	@echo "System Commands:"
	@echo "  switch-abbes - Build and switch to abbes configuration"
	@echo "  boot-abbes   - Build and set abbes as next boot"
	@echo "  test-abbes   - Test abbes configuration (temporary)"
	@echo ""
	@echo "Home Manager Commands:"
	@echo "  home-switch        - Switch home-manager configuration"
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
build-abbes:
	@echo "Building abbes configuration..."
	sudo nixos-rebuild build --flake .#abbes

build-minimal:
	@echo "Building minimal configuration..."
	sudo nixos-rebuild build --flake .#minimal

# Switch configurations
switch-abbes:
	@echo "Switching to abbes configuration..."
	sudo nixos-rebuild switch --flake .#abbes

switch-minimal:
	@echo "Switching to minimal configuration..."
	sudo nixos-rebuild switch --flake .#minimal

# Boot configurations
boot-abbes:
	@echo "Setting abbes as next boot configuration..."
	sudo nixos-rebuild boot --flake .#abbes

boot-minimal:
	@echo "Setting minimal as next boot configuration..."
	sudo nixos-rebuild boot --flake .#minimal

# Test configurations (temporary, reverts on reboot)
test-abbes:
	@echo "Testing abbes configuration (temporary)..."
	sudo nixos-rebuild test --flake .#abbes

test-minimal:
	@echo "Testing minimal configuration (temporary)..."
	sudo nixos-rebuild test --flake .#minimal

# Home Manager
home-switch:
	@echo "Switching home-manager configuration..."
	home-manager switch --flake .

# Maintenance
update:
	@echo "Updating flake inputs..."
	nix flake update

upgrade: update switch-abbes
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
