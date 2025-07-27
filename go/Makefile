# Output directory
BIN_DIR := $(HOME)/.local/bin

# Find all command directories under cmd/
COMMAND_DIRS := $(shell find cmd -mindepth 1 -maxdepth 1 -type d)

# Derive binary names from directory names
BINARIES := $(patsubst cmd/%,%,$(COMMAND_DIRS))

.PHONY: all build watch

all: build

build:
	@mkdir -p $(BIN_DIR)
	@for dir in $(COMMAND_DIRS); do \
		name=$$(basename $$dir); \
		echo "Building $$name: $(BIN_DIR)/$$name"; \
		go build -o $(BIN_DIR)/$$name ./$$dir; \
		$(BIN_DIR)/$$name _carapace fish > ~/.config/fish/completions/$${name}.fish; \
	done

watch:
	@echo "Watching for changes..."
	@while true; do \
		inotifywait -r -e modify,create,delete ./cmd ./pkg; \
		clear; \
		make build; \
	done

