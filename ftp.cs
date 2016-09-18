using System;
using System.IO;
using System.Net;

class main{
//fill out the string stuff
    static String ftpUsername = "USERNAME";
    static String ftpPassword = "PASSOWORD";
    static String url = "URL HERE";


    public static void Main()
    {

        //copy-paste-edit this code if you want multiple listeners (like different file types)
        FileSystemWatcher watcher = new FileSystemWatcher();
        watcher.Path = Directory.GetCurrentDirectory();
        watcher.NotifyFilter = NotifyFilters.LastAccess | NotifyFilters.LastWrite | NotifyFilters.FileName | NotifyFilters.DirectoryName;
        //if you want to filter file types
        watcher.Filter = "*.*";
        watcher.Created += new FileSystemEventHandler(Upload);
        watcher.Deleted += new FileSystemEventHandler(Delete);
        watcher.EnableRaisingEvents = true;
        //copu-paste code above for multiple listeners

        Console.WriteLine("Press \'q\' to quit.");
        while(Console.Read()!='q');
    }
    static void Upload(object source, FileSystemEventArgs e){
        try{
            using (WebClient client = new WebClient())
            {
                client.Credentials = new NetworkCredential(ftpUsername, ftpPassword);
                client.UploadFile(url + e.Name, "STOR", e.FullPath);
                Console.WriteLine("Uploaded " + e.Name);
            }
        }
        catch(Exception ex){
            Console.WriteLine("Unable to upload " + e.Name);
            Exception decoy = ex;
            ex = decoy;
        }
    }
    static void Delete(object source, FileSystemEventArgs e){
        try{
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(url + e.Name);
            request.Method = WebRequestMethods.Ftp.DeleteFile;
            request.Credentials = new NetworkCredential(ftpUsername, ftpPassword);
 
            using (FtpWebResponse response = (FtpWebResponse)request.GetResponse())
            {
                Console.WriteLine("Deleted " + e.Name);
                   
            }
        }
        catch(Exception ex){
            Console.WriteLine("Unable to delete " + e.Name + " (file missing?)");
            Exception decoy = ex;
            ex = decoy;
        }
    }
}