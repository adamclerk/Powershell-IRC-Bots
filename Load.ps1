cls

. .\lib\ColorCode.ps1
. .\lib\Repeat-String.ps1
. .\TodoBot.ps1
Start-TodoBot

#Get-ChildItem c:\ps1\irc\lib\*.ps1 | % { 
#      . $_
#      write-host "Loading library file:`t$($_.name)"#
	  #write-host $_
#}
#Write-Host "----------------------"
#Get-ChildItem c:\ps1\irc\SimpleBot.ps1 | % { 
#      . $_
#      write-host "Loading Bot:`t$($_.name)"
	  #write-host $_
#}

#"Starting TodoBot"
#"Bot Started Dont Touch the Powershell Prompt"
#Start-TodoBot
