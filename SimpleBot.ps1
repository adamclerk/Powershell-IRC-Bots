    ## SimpleBot 2.0
    ## A simple framework to get you started writing your own IRC bots in PowerShell
    ####################################################################################################
    ## Requires Meebey.SmartIrc4net.dll to be in your ...\WindowsPowerShell\Libraries\
    ## You can get Meebey.SmartIrc4net.dll from
    ## http://voxel.dl.sourceforge.net/sourceforge/smartirc4net/SmartIrc4net-0.4.0.bin.tar.bz2
	## Documentation: http://smartirc4net.meebey.net/docs/0.4.0/html/Meebey.SmartIrc4net.IrcClient.html
    ####################################################################################################
    Add-Type -path .\SmartIrc4net.dll
    #$null = [Reflection.Assembly]::LoadFrom("c:\Libraries\Meebey.SmartIrc4net.dll")
     
    function Start-SimpleBot {
    PARAM( $server = "10.1.3.125", [string[]]$channels = @("#deploy"), [string[]]$nick     = @("SimpleBot"), [string]$password, $realname = "SimpleBot for deployment", $port               = 6667)
     
       if(!$global:irc) {
          $global:irc = New-Object Meebey.SmartIrc4net.IrcClient
          $irc.ActiveChannelSyncing = $true # $irc will track channels for us
          # $irc.Encoding = [Text.Encoding]::UTF8
          # $irc.Add_OnError( {Write-Error $_.ErrorMessage} )
          $irc.Add_OnQueryMessage( {PrivateMessage} )
          $irc.Add_OnChannelMessage( {ChannelMessage} )
       }
       
       $irc.Connect($server, $port)
       $irc.Login($nick, $realname, 0, $nick, $password)
       ## $channels | % { $irc.RfcJoin( $_ ) }
       foreach($channel in $channels) { $irc.RfcJoin( $channel ) }
       Resume-SimpleBot # Shortcut so starting this thing up only takes one command
    }
     
    ## Note that SimpleBot stops listening if you press a key ...
    ## You'll have to re-run Resume-SimpleBot to get him to listen again
    function Resume-SimpleBot {
       while(!$Host.UI.RawUI.KeyAvailable) { $irc.ListenOnce($false) }
    }
     
    function Stop-SimpleBot {
       $irc.RfcQuit("If people listened to themselves more often, they would talk less.")
       $irc.Disconnect()
    }
     
    ####################################################################################################
    ## Event Handlers
    ####################################################################################################
    ## Event handlers in powershell have TWO automatic variables: $This and $_
    ##   In the case of SmartIrc4Net:
    ##   $This  - usually the connection, and such ...
    ##   $_     - the IrcEventArgs, which just has the Data member:
    ##
     
    function PrivateMessage {
		
       $Data = $_.Data
       #Write-Host("Private Message Recieved")
	   #Write-Host $Data.From  
       #Write-Host $Data.Message
       #Write-Host $($Data | Out-String)
       
       $command, $params = $Data.MessageArray
       if($SimpleBotPublicCommands.ContainsKey($command)) {
		  &$SimpleBotPublicCommands[$command] $params $Data |  Out-String -width (510 - $Data.From.Length - $nick.Length - 3) | % { $_.Trim().Split("`n") | %{ $irc.SendReply($Data, $_.Trim() ) }}
       }
    }
     
    function ChannelMessage {
	   Write-Host "Channel Message Received"
       $Data = $_.Data
       #Write-Host $Data.From
       #Write-Host $Data.Channel
       #Write-Host $Data.Message
       Write-Host $($Data | Out-String)
       
       $command, $params = $Data.MessageArray
       if($SimpleBotPrivateCommands.ContainsKey($command)) {
          &$SimpleBotPrivateCommands[$command] $params $Data | Out-String -width (510 - $Data.Channel.Length - $nick.Length - 3) | % { $_.Trim().Split("`n") | %{ $irc.SendMessage("Message", $Data.Channel, $_.Trim() ) }}
       }
	   Write-Host "Channel Message Done"
    }
     
    ####################################################################################################
    ## The SimpleBotCommands hashtable is extremely simple ...
    ##
    ## You register a "command" which must be the FIRST WORD of a message (either private, or channel)
    ##   and you provide a scriptblock to process said message.  
    ## The handler scriptblock gets two parameters, for convenience:
    ##   $Params is the rest of the message text after the command word (which is probably all you need)
    ##   $Data is the Data propert of the IrcEventArgs, which has everything in it that you could want
    ##
    ## You may do whatever you want in the scriptblock (this runs on your PC, after all), but the
    ##   simplest thing is to respond by returning "something" which will be sent to wherever the message
    ##   came from.  
    ##
    ## NOTE 1: Evrything you return is output to Out-String and then the channel or user.  Be careful!
    ## NOTE 2: 510 is the Max IRC Message Length, including the channel name etc.
    ##         http`://www.faqs.org/rfcs/rfc1459.html
    ##
    
	$SimpleBotPublicCommands=@{}
	$SimpleBotPrivateCommands=@{}
     
    #A sample command to get you started
    $SimpleBotPublicCommands."Hello" = {Param($Query,$Data)
       "Hello, $($Data.Nick)!"
    }
    
    ##$SimpleBotCommands."!Echo" = {Param($Query,$Data)
    ##   "$Query"
    ##}
    ##
     
#    $SimpleBotPublicCommands."!Get-Help" = {Param($Query)
#       $help = get-help $Query | Select Name,Synopsis,Syntax
#       if($?) {
#          if($help -is [array]) {
#             "You're going to need to be more specific, I know all about $((($help | % { $_.Name })[0..($help.Length-2)] -join ', ') + ' and even ' + $help[-1].Name)"
#          } else {
#             @($help.Synopsis,($help.Syntax | Out-String -width 1000).Trim().Split("`n",4,"RemoveEmptyEntries")[0..3])
#          }
#       } else {
#          "I couldn't find the help file for '$Query', sorry.  I probably don't have that snapin loaded."
#       }
#    }
