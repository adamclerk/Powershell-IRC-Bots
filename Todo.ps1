#Write-Host "Starting Todo"
function Get-Item-Color($item)
{
	if ($item.hasFailed -eq "1")
		{
			#fail
			return (ColorCode white red )
		} 
		else 
		{ 	
			if ($item.completedBy -ne "")
			{
				#completed but not failed
				return (ColorCode white green)
			} 
			elseif($item.takenBy -ne "") 
			{ 
				#not complted byt taken
				return (ColorCode white blue)
			} 
			else 
			{
				#not taken
				return (ColorCode white black)
			} 
		}
}

function Print-Todo()
{
	$i = 0
	$todo = Get-List TodoList.txt
	(ColorCode white black) + (Repeat-String "*" 57)
	ForEach($item in $todo)
	{
		$length = [int]50 - [int]$item.task.length
		$color = Get-Item-Color($item)
		$color + "* " + ($i) + ": " + $item.task + (Repeat-String " "  $length) + " *"	 
		$i = $i+1
	}
	(ColorCode white black ) + (Repeat-String "*" 57)
}

function Add-Todo($Task)
{
	$file = "C:\ps1\irc\TodoList.txt"
	$xml = New-Object XML
	$xml.Load($file)
	
	$oldItem = @($xml.list.item)[0]
	$newItem = $oldItem.Clone()
	$newItem.task = $Task.Replace("_", " ")
	$newItem.hasFailed = "0"
	$newItem.takenBy = ""
	$newItem.completedBy = ""
	$newItem.completedOn = ""
	
	$newItem = $xml.list.appendChild($newItem)
	
	$xml.Save($file)
	"Added $Task"
}

function Take-Todo($TaskId, $User)
{
	$file = "C:\ps1\irc\TodoList.txt"
	$xml = New-Object XML
	$xml.Load($file)
	$oldItem = @($xml.list.item)[[int]$TaskId]
	
	if($oldItem -eq $null)
	{
		"Invalid Task"
	}
	else
	{
		if($oldItem.takenBy -eq "")
		{
		
			$newItem = $oldItem.Clone()
			$newItem.takenBy = [string]$User
			$newItem = $xml.list.ReplaceChild($newItem, $oldItem)
		
			$xml.Save($file)
		
			"You've taken task: "  + ($TaskId) + ": " + $newItem.task
		}
		else
		{
			$oldItem.takenBy + " has beat you to the punch"
		}
	}
}

function Insert-Todo($Task, $Before)
{
	$file = "C:\ps1\irc\TodoList.txt"
	$xml = New-Object XML
	$xml.Load($file)

	$oldItem = @($xml.list.item)[[int]$Before]
	$newItem = $oldItem.Clone()
	$newItem.task = $Task.Replace("_", " ")
	$newItem.hasFailed = "0"
	$newItem.takenBy = ""
	$newItem.completedBy = ""
	
	$newItem = $xml.list.InsertBefore($newItem, $oldItem)
	$xml.Save($file)
	"Inserted $Task"
}

function Mark-Todo($TaskId, $User)
{
	$file = "C:\ps1\irc\TodoList.txt"
	$xml = New-Object XML
	$xml.Load($file)
	$oldItem = @($xml.list.item)[[int]$TaskId]
	
	if($oldItem -eq $null)
	{
		"Invalid Task"
	}
	else
	{
		if($oldItem.takenBy -ne $User)
		{
			"Only " + $oldItem.takenBy + " can complete this item"
		}
		elseif($oldItem.completedBy -eq "")
		{	
			$newItem = $oldItem.Clone()
			$newItem.completedBy = [string]$User
			$a = Get-Date
			$newItem.completedOn = $a.ToShortTimeString()
			$newItem = $xml.list.ReplaceChild($newItem, $oldItem)
		
			$xml.Save($file)
		
			"You've completed task: " + ($TaskId) + ": " + $newItem.task
		}
		else
		{
			$oldItem.takenBy + " has beat you to the punch"
		}
	}
}

function Info-Todo($TaskId)
{
	$file = "C:\ps1\irc\TodoList.txt"
	$xml = New-Object XML
	$xml.Load($file)
	
	$item = @($xml.list.item)[[int]$TaskId]
	
	if($item -eq $null)
	{
		"Invalid Task"
	}
	else
	{
		$color = Get-Item-Color($item)
		(ColorCode white black) + (Repeat-String "*" 57)
		$color + "* Task: " + $item.task + (Repeat-String " " (47-$item.task.Length)) + " *"
		$color + "* Taken By: " + $item.takenBy + (Repeat-String " " (43-$item.takenBy.Length)) + " *"
		$color + "* Has Failed: " + $item.hasFailed + (Repeat-String " " (41-$item.hasFailed.Length)) + " *"
		$color + "* Failed By: " + $item.failedBy + (Repeat-String " " (42-$item.failedBy.Length)) + " *"
		$color + "* Completed By: " + $item.CompletedBy + (Repeat-String " " (39-$item.CompletedBy.Length)) + " *"
		$color + "* Completed At: " + $item.completedOn + (Repeat-String " " (39-$item.completedOn.Length)) + " *"
		(ColorCode white black) + (Repeat-String "*" 57)
	}
}

function Fail-Todo($TaskId, $User)
{
	$file = "C:\ps1\irc\TodoList.txt"
	$xml = New-Object XML
	$xml.Load($file)
	$oldItem = @($xml.list.item)[[int]$TaskId]
	
	if($oldItem -eq $null)
	{
		"Invalid Task"
	}
	else
	{	
		$newItem = $oldItem.Clone()
		$newItem.failedBy = [string]$User
		$newItem.hasFailed = "1"
		$newItem = $xml.list.ReplaceChild($newItem, $oldItem)

		$xml.Save($file)

		"You've failed task: " + ($TaskId) + ": " + $newItem.task
	}
}

function Help-Todo()
{
	(ColorCode "black" "light grey") +  "*********************************************************"
	(ColorCode "black" "light grey") + 	"* Here are all the commands I respond to                *"
	(ColorCode "black" "grey") + 	   	"* add taskname                                          *"
	(ColorCode "black" "light grey") + 	"* - adds 'taskname' to the end of the list              *"
	(ColorCode "black" "light grey") + 	"* - 'taskname' must be one word or words separated by _ *"
	(ColorCode "black" "light grey") + 	"* - Example: add Deploy_DB                              *"
	(ColorCode "black" "light grey") + 	"*                                                       *"
	(ColorCode "black" "grey") + 	   	"* insert taskname 1                                     *"
	(ColorCode "black" "light grey") + 	"* - inserts 'taskname' before task #1 in the  list      *"
	(ColorCode "black" "light grey") + 	"* - this command must have a taskname and a number      *"
	(ColorCode "black" "light grey") + 	"* - reference the todolist to get the correct number    *"
	(ColorCode "black" "light grey") + 	"* - list numbering starts at 0                          *"
	(ColorCode "black" "light grey") + 	"* - Example: insert Deploy_Code 3                       *"
	(ColorCode "black" "light grey") + 	"*                                                       *"
	(ColorCode "black" "grey") + 	    "* info 1                                                *"
	(ColorCode "black" "light grey") + 	"* - get the info for this task                          *"
	(ColorCode "black" "light grey") + 	"*                                                       *"
	(ColorCode "black" "grey") + 	    "* take 1                                                *"
	(ColorCode "black" "light grey") + 	"* - take a task. by taking this task you must to do it  *"
	(ColorCode "black" "light grey") + 	"* - if you don't complete it...we know where you live   *"
	(ColorCode "black" "light grey") + 	"*                                                       *"
	(ColorCode "black" "grey") + 		"* done 1                                                *"
	(ColorCode "black" "light grey") + 	"* - this is how you finish a task                       *"
	(ColorCode "black" "light grey") + 	"* - you can only finish a task you've taken             *"
	(ColorCode "black" "light grey") + 	"*                                                       *"
	(ColorCode "black" "grey") + 		"* fail 1                                                *"
	(ColorCode "black" "light grey") + 	"* - this is how you fail a task                         *"
	(ColorCode "black" "light grey") + 	"*                                                       *"
	(ColorCode "black" "light grey") +  "*********************************************************"
}

$query = [string]$args[0];
$param = $args[1];
$query = $query.split(" ");

switch($query[0])
{
	"add"   { Add-Todo $query[1] }
	"insert" { Insert-Todo $query[1] $query[2]}
	"take"  { Take-Todo $query[1] $param.Nick}
	"done"  { Mark-Todo $query[1] $param.Nick}
	"info"  { Info-Todo $query[1]}
	"fail"	{ Fail-Todo $query[1] $param.Nick}
	"help"  { Help-Todo }
	default {Print-Todo}
}
#Write-Host "Ending Todo"

