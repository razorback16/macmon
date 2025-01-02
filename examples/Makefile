# Compiler and flags
CC = clang
CFLAGS = -Wall -I.
SWIFTC = swiftc
SWIFTFLAGS = -I.

# Rust library paths
RUST_LIB_DIR = ../target/release
RUST_LIB = macmon

# Output
TARGET = monitor
MACMON_TARGET = macmon-example

# Default target
all: $(TARGET) $(SWIFT_TARGET) $(MACMON_TARGET)

# Build Rust library first
$(RUST_LIB_DIR)/lib$(RUST_LIB).dylib:
	cd .. && cargo build --release
	cp $(RUST_LIB_DIR)/lib$(RUST_LIB).dylib .

# Build C example and link with Rust library
$(TARGET): example.c $(RUST_LIB_DIR)/lib$(RUST_LIB).dylib
	$(CC) $(CFLAGS) -o $@ example.c -L$(RUST_LIB_DIR) -l$(RUST_LIB)

# Run the example (sets library path)
run: $(TARGET)
	DYLD_LIBRARY_PATH=$(RUST_LIB_DIR) ./$(TARGET)

# Build MacMon example
$(MACMON_TARGET): MacMon.swift MacMonExample.swift $(RUST_LIB_DIR)/lib$(RUST_LIB).dylib
	$(SWIFTC) $(SWIFTFLAGS) -o $@ MacMon.swift MacMonExample.swift

# Run the MacMon example
run-macmon: $(MACMON_TARGET)
	DYLD_LIBRARY_PATH=$(RUST_LIB_DIR) ./$(MACMON_TARGET)

# Clean build artifacts
clean:
	rm -f $(TARGET) $(SWIFT_TARGET) $(MACMON_TARGET)

.PHONY: all run run-swift clean
