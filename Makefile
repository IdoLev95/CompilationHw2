# Define source and object files
SOURCES = parser.y edit_part1.lex part2_helpers.c
OBJECTS = $(SOURCES:.cpp=.o) $(SOURCES:.c=.o)  # Include both C++ and C object files

# Define the output executable
EXEC = parser

# Compiler and flags
CXX = g++
CC = gcc
CXXFLAGS = -std=c++17 -Wall -g
CCFLAGS = -Wall -g

# Linker flags
LDFLAGS = -lfl

# Bison and Flex commands
BISON = bison
FLEX = flex

# Generated files
BISON_OUTPUT = parser.tab.c
BISON_HEADER = parser.tab.h
FLEX_OUTPUT = lex.yy.c

# Rule to generate the parser and lexer files
$(BISON_OUTPUT) $(FLEX_OUTPUT): parser.y edit_part1.lex
	$(BISON) -d parser.y || (echo "Bison failed!"; exit 1)
	$(FLEX) edit_part1.lex || (echo "Flex failed!"; exit 1)

# Default rule to build the executable
$(EXEC): $(BISON_OUTPUT) $(FLEX_OUTPUT) part2_helpers.c $(OBJECTS)
	$(CXX) $(OBJECTS) -o $(EXEC) $(LDFLAGS)

# Rule to compile C++ source files into object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Rule to compile C source files into object files
%.o: %.c
	$(CC) $(CCFLAGS) -c $< -o $@

# Clean rule
clean:
	rm -f $(EXEC) $(BISON_OUTPUT) $(BISON_HEADER) $(FLEX_OUTPUT) *.o


# Make sure part2_helpers.c is not erased (add this file explicitly)
part2_helpers.c:
	@echo "part2_helpers.c not found, make sure it exists and is not deleted."

