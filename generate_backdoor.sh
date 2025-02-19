#!/bin/sh

init_script="hooks/init.sh"
before_command_script="hooks/before.sh"
after_command_script="hooks/after.sh"

header_file="bash/backdoor.h"

# Check for existence of files
for script in "$init_script" "$before_command_script" "$after_command_script"; do
	if [ ! -f "$script" ]; then
		echo "Warning: '$script' not found"
	else
		echo "Script: '$script' found"
	fi
done

echo ""
echo "――――――――――――――――――――――――――――――――――――――――――――――――"

# Print out file contents
for script in "$init_script" "$before_command_script" "$after_command_script"; do
	total_length=40
	padding_width=$(( (total_length - ${#script}) / 2 - 1 ))

	header="$(printf '%s%s%s\n' "$(printf -- '-%.0s' $(seq $padding_width))" " $script " "$(printf -- '-%.0s' $(seq $padding_width))")"
	footer=$(printf "%${#header}s" | tr ' ' '-')

	echo ""
	echo "$header"
	cat $script 2>/dev/null
	echo "$footer"
	echo ""
done

echo "――――――――――――――――――――――――――――――――――――――――――――――――"
echo ""

if [ -f "$header_file" ]; then
	echo "Warning: '$header_file' found"
	echo "Overwriting..."
	rm $header_file
fi

# OH DEAR GOD WHYYYYYYY
MACRO_NAMES=("INIT_SCRIPT" "BEFORE_CMD_SCRIPT" "AFTER_CMD_SCRIPT")
FILE_NAMES=("$init_script" "$before_command_script" "$after_command_script")

for i in "${!MACRO_NAMES[@]}"; do
	echo "#define ${MACRO_NAMES[i]} \"\" \\" >> $header_file

	while IFS= read -r line; do
		escaped_line=$(echo "$line" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')
		echo "	\"$escaped_line\\n\" \\" >> "$header_file"
	done < "${FILE_NAMES[i]}"

	echo >> "$header_file"

done 2>/dev/null


echo ""
echo "----------------- backdoor.h -----------------"
cat backdoor.h
echo "----------------------------------------------"
echo ""
echo "Success!"
