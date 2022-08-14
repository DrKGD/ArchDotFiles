## Generate list of fields
make_format(){
	# string with tokens
	elabel="$(echo "$1" | sed -Ee 's/@[^[:space:]@%#\:]*/@@/g')"

	# (g)lobal, t skip, (d)elete line
	tokens="$(echo "$1" | sed -Ee 's/[^@]*@([^[:space:]@%#\:]*)[^@]*/\1 /g;t;d')"
}

## Evaluate list of fields
make_string(){
	local output="$elabel"
	
	# Replace tokens with value 
	for K in ${tokens^^}; do
		output="$(echo "$output" | sed -Ee "s/@@/${!K:-?$K}/" )"
	done

	# Interpret single slash as separation 
	# TODO: Interpret two slashes as slash
	printf '%s\n' $output | sed 's/\\//g'
}
