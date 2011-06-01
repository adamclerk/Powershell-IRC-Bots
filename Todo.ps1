$i = 0
Get-List TodoList.txt | ForEach-Object {if ($_.hasFailed -eq "1"){ (ColorCode red) + $_.task} else { if ($_.completedBy -ne ""){(ColorCode green) + $_.task} elseif($_.takenBy -ne "") { (ColorCode blue) + $_.task} else {(ColorCode black) + $_.task } } $i = $i+1}
