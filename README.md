#RaGeBMC 

RageBMC is a automated configuration voor Raspbmc.
It carries transmission, flexget xbmc and fish.

##Install

Install root file system and go though the first boot of Raspbmc.
Login via terminal and set root password.
The default username and password for Raspbmc are:

    user: pi
    passwd: raspberry
    
To set root password use

    sudo passwd root
    
Logout or `su root` to gain root acces and run:

    bash <( curl "https://raw2.github.com/RamonGebben/ragebmc/master/install/install.sh")
    
When the script is done, reboot.
After reboot you will need to run 

    fish

this will give you an nice prompt and give you the ability to run the RaGeBMC scripts. use it to run 

    rb-upgrade
    
This will install en configure the rest except for the flexget crontab and useraccount.


###Transmission

[Trasmissionbt](http://www.transmissionbt.com/) is a Open Source Bittorrent client. One of the great features is the web interface. 

This way you can run a torrent client without an graphic interface.
The web interface is available at poort 9091.

    ragebmc.local:9091
    
Here you can add torrents, you can choose to download into the download folder, or you can edit the destination folder when you add it.
The available folder are:

- download
- movies
- series

###ShowRSS

[ShowRSS](http://showrss.info) is wonderfull initiative, it gives you the ability to add a show to your list, and if you Flexget feed is set correctly, it will start downloading that show from the next aired episode.

###Flexget

[Flexget](http://flexget.com) gives you the ability to add an RSS feed from torrent links, and automatically add these torrents to transmission.

To set your ShowsRSS account edit the `config.yml` in the folder `/ragebmc/.flexget/`
Paste your feed where it saids

     feed: http://showrss.info/rss.php?user_id=151505&hd=null&proper=null&namespaces=true 

And run

    flexget execute
    
To make it check for downloads every 30min add flexget to crontab.
Use 

    crontab -e

And add this line.    

    */15 * * * * /usr/local/bin/flexget


