# Compiler and Tools
CC = gcc
FLEX = flex
BISON = bison

# Compiler Flags
CFLAGS = -Wall -Wno-unused-function -g
LDFLAGS = -lfl

# Source Files
LEX_FILE = edit_part1.lex
BISON_FILE = parser.y
HELPERS_FILE = part2_helpers.c

# Generated Files
LEX_C = lex.yy.c
BISON_C = parser.tab.c
BISON_H = parser.tab.h

# Output
TARGET = parser

# Default Rule
all: $(TARGET)

# Flex Rule
$(LEX_C): $(LEX_FILE)
	$(FLEX) $(LEX_FILE)

# Bison Rule
$(BISON_C) $(BISON_H): $(BISON_FILE)
	$(BISON) -d $(BISON_FILE)

# Build Parser
$(TARGET): $(LEX_C) $(BISON_C) $(HELPERS_FILE)
	$(CC) $(CFLAGS) -o $(TARGET) $(LEX_C) $(BISON_C) $(HELPERS_FILE) $(LDFLAGS)

# Clean Rule
clean:
	rm -f $(LEX_C) $(BISON_C) $(BISON_H) $(TARGET)

# Debug Rule
debug:
	$(CC) $(CFLAGS) -o $(TARGET) $(LEX_C) $(BISON_C) $(HELPERS_FILE) $(LDFLAGS)

