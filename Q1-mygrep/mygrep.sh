#!/bin/bash
#
# mygrep.sh - A mini version of grep supporting -n, -v options
print_help() {
	echo "Usage: $0 [options] search_string filename"
	echo ""
	echo "Options:"
      	echo "  -n       Show line numbers for matching lines."
	echo "  -v       Invert match: show lines that do NOT match."
        echo "  --help   Display this help message."
	exit 0
}

#check if no arguments are provided
if [ $# -lt 2 ]; then
       	echo "Error: Missing search string or filename."
	print_help
	exit 1
fi

# Create two Boolean variables:
# show_line_numbers: To display line numbers & invert_match: To show non-matching lines.
show_line_numbers=false
invert_match=false

# Parse options
# Initialize option flags
# show_line_numbers=false
# invert_match=false
#
# # Parse options
while [[ "$1" == -* ]]; do
	case "$1" in
		--help)
		   print_help
		   ;;
		-*)
	  # Parse each character after '-'
	  opt_chars="${1:1}"
	  for (( i=0; i<${#opt_chars}; i++ )); do
		case "${opt_chars:$i:1}" in	            
			n) show_line_numbers=true ;;	
			v) invert_match=true ;;													*) echo "Error: Invalid option -${opt_chars:$i:1}" ; print_help ; exit 1 ;;    
      		esac              
		done 
		;;  
	esac 
	shift
done

# After options, we should have exactly 2 arguments: search_string and filename
if [ $# -ne 2 ]; then
	echo "Error: Missing or too many arguments."
	print_help
	exit 1
fi

# Next should be search_string and filename
search_string="$1"
filename="$2"

# Checking if the file actually exists.
if [ ! -f "$filename" ]; then
	echo "Error: File '$filename' does not exist."
	exit 1
fi

# Read and process the file
line_number=0

while IFS= read -r line; do
	((line_number++))
 
	# Perform a case-insensitive search
	if echo "$line" | grep -i -q "$search_string"; then
		match=true
	else
		match=false
	fi

	# Invert match if -v option is set
	if $invert_match; then
		match=$(! $match && echo true || echo false)
	fi

	# Output the result
	if $match; then
		if $show_line_numbers; then
			echo "${line_number}:$line"
		else
			echo "$line"
		fi
	fi
done < "$filename"

