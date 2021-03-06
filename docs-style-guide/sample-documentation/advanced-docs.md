# Rocky Linux Advanced Docs Style Guide

## Intro

Advanced documentation is what we call the docs that have *everything* laid out and explained in detail, but are still targeted at the technically-proficient. If you've got nerd jokes to share, use them to spice up the writing a bit.

----

# Advanced Docs Example: Apache Web Server Multi-Site Setup

Rocky Linux has many ways for you to setup a web site. This is just one method, using Apache, and is designed for use as a multi-site setup on a single server. While this method is designed for multi-site servers, it can also act as a base configuration for a single site server as well. 

History fact: This server setup appears have started with Debian-based systems, but it is perfectly adaptable to any Linux OS running Apache.

## What You Need
* A server running Rocky Linux
* Knowledge of the command-line and text editors (This example uses *vi*, but can be adapted to your favorite editor.)
    * If you'd like to learn about the vi text editor, [here's a handy tutorial](https://www.tutorialspoint.com/unix/unix-vi-editor.htm).
* Basic knowledge about installing and running web services

## Install Apache
You'll likely need other packages for your web site. For instance, a version of PHP will almost certainly be required, and maybe a database or other package will be needed as well. Installing PHP along with httpd will get you the latest version of both from the Rocky Linux repositories. 

Just remember that you may need modules as well, like perhaps php-bcmath or php-mysqlind. Your web application specifications should detail what is needed. These can be installed at any time. For now, we will install httpd and PHP, as those are almost a forgone conclusion:

* From the command-line run `dnf install httpd php`

## Add Extra Directories

This method uses a couple of additional directories, but they don't currently exist on the system. We need to add two directories in */etc/httpd/* called "sites-available" and "sites-enabled."

* From the command-line type `mkdir /etc/httpd/sites-available` and then `mkdir /etc/httpd/sites-enabled`

* We also need a directory where our sites are going to reside. This can be anywhere, but a good way to keep things organized is to create a directory called sub-domains. To keep things simple, put this in /var/www: `mkdir /var/www/sub-domains/`

## Configuration
We also need to add a line to the very bottom of the httpd.conf file. To do this, type `vi /etc/httpd/conf/httpd.conf` and go to the bottom of the file and add `Include /etc/httpd/sites-enabled`.

Our actual configuration files will reside in */etc/httpd/sites-available* and we will simply symlink to them in */etc/httpd/sites-enabled*. 

**Why do we do this?**

The reason here is pretty simple. Let's say you have 10 web sites all running on the same server on different IP addresses. Let's say that site B has some major updates and you have to make changes to the configuration for that site. Let's say too, that there is something wrong with the changes made, so when you restart httpd to read in the new changes, httpd doesn't start. 

Not only will the site you were working on not start, but neither will the rest of them. With this method, you can simply remove the symbolic link for the site that caused the failure, and restart httpd. It???ll start working again, and you can go to work, trying to fix the broken site configuration. 

It sure takes the pressure off, knowing that the phone isn't going to ring with some angry customer, or an angry boss, because a service is off-line.

### The Site Configuration
The other benefit of this method is that it allows us to fully specify everything outside of the default httpd.conf file. Let the default httpd.conf file load the defaults, and let your site configurations do everything else. Sweet, right? Plus again, it makes it very easy to trouble-shoot a broken site configuration. 

Now, let's say you have a web site that loads a wiki. You???ll need a config file, which makes the site available via port 80. If you want to serve the website with SSL (and let's face it, we all should be doing that by now) then you need to add another (nearly identitcal) section to the same file, in order to enable port 443.

So we first need to create this configuration file in *sites-available*: `vi /etc/httpd/sites-available/com.wiki.www`

The configuration file configuration content would be something like this:

```
<VirtualHost *:80>
        ServerName www.wiki.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.wiki.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.wiki.www/cgi-bin/

	CustomLog "/var/log/httpd/com.wiki.www-access_log" combined
	ErrorLog  "/var/log/httpd/com.wiki.www-error_log"

        <Directory /var/www/sub-domains/com.wiki.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```
Once the file is created, we need to write (save) it with: `shift : wq`

In our example above, the wiki site is loaded from the the html sub-directory of com.wiki.www, which means that our path we created in /var/www (above) will need some additional directories to satisfy this:

`mkdir -p /var/www/sub-domains/com.wiki.www/html`

... which will create the entire path with a single command. Next we would want to install our files to this directory that will actually run the web site. This could be something that was created by you or an application, in this case a wiki, that you downloaded. Copy your files to the path above:

`cp -Rf wiki_source/* /var/www/sub-domains/com.wiki.www/html/`

## Taking It Live

Remember that our *httpd.conf* file is including */etc/httpd/sites-enabled* at the very end of the file, so when httpd restarts, it will load whatever configuration files are in that *sites-enabled* directory. Thing is, all of our configuration files are in *sites-available*. 

That's by design, so that we can easily remove things in the event that httpd fails to restart. So to enable our configuration file, we need to create a symbolic link to that file in *sites-enabled* and then start or restart the web service. To do this, we use this command:

`ln -s /etc/httpd/sites-available/com.wiki.www /etc/httpd/sites-enabled/`

This will create the link to the configuration file in *sites-enabled*, just like we want.

Now just start httpd with `systemctl start httpd`. Or restart it if it???s already running: `systemctl restart httpd`, and assuming the web service restarts, you can now go and do some testing on your new site.
