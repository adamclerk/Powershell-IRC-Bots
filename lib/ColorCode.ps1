function ColorCode {
    PARAM( [string]$foreColor = "black", [string]$backColor = "white" )
	
	$code = [char]3
	switch -wildcard ($foreColor)
	{
		"white" {$code = $code + "0"}
		"black" {$code = $code + "1"}
		"blue" 	{$code = $code + "2"}
		"green" {$code = $code + "3"} 
		"red" 	{$code = $code + "4"} 
		"brown" {$code = $code + "5"}
		"purple" {$code = $code + "6"} 
		"orange" {$code = $code + "7"}
		"yellow" {$code = $code + "8"} 
		"light green" {$code = $code + "9"}
		"teal" {$code = $code + "10"}
		"light cyan" {$code = $code + "11"}
		"light blue" {$code = $code + "12"}
		"pink" {$code = $code + "13"}
		"grey" {$code = $code + "14"}
		"light grey" {$code = $code + "15"}
		default {$code = $code + "1"}
	}
	
	switch ($backColor)
	{
		"white" {$code = $code + ",0"}
		"black" {$code = $code +  ",1"}
		"blue" 	{$code = $code +  ",2"}
		"green" {$code = $code +  ",3"} 
		"red" 	{$code = $code +  ",4"} 
		"brown" {$code = $code +  ",5"}
		"purple" {$code = $code +  ",6"} 
		"orange" {$code = $code +  ",7"}
		"yellow" {$code = $code +  ",8"} 
		"light green" {$code = $code +  ",9"}
		"teal" {$code = $code +  ",10"}
		"light cyan" {$code = $code +  ",11"}
		"light blue" {$code = $code +  ",12"}
		"pink" {$code = $code +  ",13"}
		"grey" {$code = $code +  ",14"}
		"light grey" {$code = $code +  ",15"}
		default {$code = $code +  ",0"}
	}
	
	$code
	
}