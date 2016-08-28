#global variable stuff -CHANGE!!!
#local path of the folder you want to sync
$localPath = "YOUR LOCAL PATH"

#path to FTP site. Example: ftp://example.com/folder/to/upload/to (no end slash)
$FTPPath = ""

#filter specific files by name/type
$filter = "fileFilter.*"

#username and password for server
$username = "username"
$password = "password"

#include subdirectories
$inclSubDirectories = $true


#end of user defined variables


    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $localPath
    $watcher.Filter = $filter
    $watcher.IncludeSubdirectories = $inclSubDirectories
    $watcher.EnableRaisingEvents = $true  


    $action = { $path = $Event.SourceEventArgs.FullPath
                $changeType = $Event.SourceEventArgs.ChangeType
                $logline = "$(Get-Date), $changeType, $path"
                Add-content "${localPath}\log.txt" -value $logline
                $File = $path
                $fileName = $Event.SourceEventArgs.Name
                $ftp = "${username}:${password}@${FTPPath}/${fileName}"
 
                "ftp url: $ftp"
 
                $webclient = New-Object System.Net.WebClient
                $uri = New-Object System.Uri($ftp)
 
                "Uploading $File..."
 
                $webclient.UploadFile($Uri, $File)
                $webclient.Close()
              }
    $action2 = { $path = $Event.SourceEventArgs.FullPath
                 $changeType = $Event.SourceEventArgs.ChangeType
                 $logline = "$(Get-Date), $changeType, $path"
                 Add-content "'$localPath'\log.txt" -value $logline
                 $File = $path
                $fileName = $Event.SourceEventArgs.Name

                $ftprequest = [System.Net.FtpWebRequest]::Create("${username}:${password}@${FTPPath}/${fileName}")
  
 
	            $ftprequest.Credentials = New-Object System.Net.NetworkCredential($username,$password)
	
	            $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile
	
  
	            $ftpresponse = $ftprequest.GetResponse()  
	            $ftpresponse
                }

    $created = Register-ObjectEvent $watcher "Created" -Action $action
    $deleted = Register-ObjectEvent $watcher "Deleted" -Action $action2
    while ($true) {sleep 5}
