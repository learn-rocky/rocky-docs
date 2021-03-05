# SAT: Software Assissted Translation

or semi-automated translation per Calder Sheagren.


Save time in most case if using good tranlation engine.

```
a.txt --> SAT --> a.sat.txt--> Human Brain --> a.final.txt

```


# Using google translate command line tool

## install
pip3 install googletrans==3.1.0a0

```
[x220@ipa01 py-googletrans]$ translate "veritas lux mea" -s la -d en
[la] veritas lux mea
    ->
    [en] The truth is my light
    [pron.] The truth is my light
[x220@ipa01 py-googletrans]$
```

## demo

```
[x220@ipa01 rocky-docs]$ translate  "服务器多站点设置"
    [zh-CN] 服务器多站点设置
    ->
    [en] Server multi-site settings
    [pron.] None
[x220@ipa01 rocky-docs]$
```

## SC to TC

```
[x220@ipa01 rocky-docs]$ translate  "服务器多站点设置" -d zh-tw
[zh-CN] 服务器多站点设置
    ->
[zh-tw] 服務器多站點設置
[pron.] Fúwùqì duō zhàn diǎn shèzhì
[x220@ipa01 rocky-docs]$ 
```


# Using translate-shell

## trans version info
```
[x220@ipa01 rocky-docs]$ trans -V
Translate Shell       0.9.6.12-git:468841e

platform              Linux
terminal type         dumb
bi-di emulator        [N/A]
gawk (GNU Awk)        5.1.0
fribidi (GNU FriBidi) 1.0.10
audio player          [NOT INSTALLED]
terminal pager        less
web browser           xdg-open
user locale           en_US.UTF-8 (English)
home language         en
source language       auto
target language       en
translation engine    google
proxy                 [NONE]
user-agent            Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
ip version            [DEFAULT]
theme                 default
init file             [NONE]

Report bugs to:       https://github.com/soimort/translate-shell/issues

[x220@ipa01 rocky-docs]$ 
```

## default using google translate engine (beware of transaltion rate limit)

```
[x220@ipa01 rocky-docs]$ cat /home/x220/github/rocky-docs/greet.txt
வணக்கம். எப்படி இருக்கீங்க?
[x220@ipa01 rocky-docs]$
[x220@ipa01 translate-shell]$ trans file:///home/x220/github/rocky-docs/greet.txt :zh-tw
你好。你好吗？
[x220@ipa01 translate-shell]$
```
### Now translate an Enlish file to ZH-TW language

```
[x220@ipa01 translate-shell]$ trans file:///home/x220/github/rocky-docs/apache-sites-enabled.english.md  :zh-tw
---
标题：“ Apache Web服务器多站点设置”
---

＃Apache Web服务器多站点设置

Rocky Linux提供了许多方法来设置网站。这只是使用Apache的一种方法，旨在用作单个服务器上的多站点设置。尽管此方法是为多站点服务器设计的，但它也可以作为单个站点服务器的基本配置。

历史事实：此服务器设置似乎是从基于Debian的系统开始的，但它完全适合于任何运行Apache的Linux操作系统。

##您需要什么
*运行Rocky Linux的服务器
*命令行和文本编辑器的知识（此示例使用* vi *，但可以适应您喜欢的编辑器。）
*如果您想了解vi文本编辑器，请[这里是一个方便的教程]（https://www.tutorialspoint.com/unix/unix-vi-editor.htm）。
*有关安装和运行Web服务的基本知识

##安装Apache
您可能需要网站的其他软件包。例如，几乎肯定会需要一个PHP版本，并且可能还需要一个数据库或其他软件包。将PHP与httpd一起安装将使您从Rocky Linux存储库中获得最新版本。

请记住，您可能还需要模块，例如php-bcmath或php-mysqlind。您的Web应用程序规范应详细说明所需的内容。这些可以随时安装。现在，我们将安装httpd和PHP，因为它们几乎已成定局：

*从命令行运行`dnf install httpd php`

##添加额外目录

此方法使用了几个其他目录，但是它们当前在系统上不存在。我们需要在* / etc / httpd / *中添加两个目录，分别称为“ sites-available”和“ sites-enabled”。

*从命令行输入`mkdir / etc / httpd / sites-available`，然后输入`mkdir / etc / httpd / sites-enabled`

*我们还需要一个目录，这些目录将用来存放我们的网站。它可以在任何地方，但是使事情井井有条的一个好方法是创建一个名为子域的目录。为了简单起见，请将其放在/ var / www中：`mkdir / var / www / sub-domains /`

＃＃ 配置
我们还需要在httpd.conf文件的最底部添加一行。为此，输入`vi / etc / httpd / conf / httpd.conf`并转到文件底部，然后添加`Include / etc / httpd / sites-enabled`。

我们的实际配置文件将位于* / etc / httpd / sites-available *中，而我们将在* / etc / httpd / sites-enabled *中简单地符号链接到它们。

**我们为什么要做这个？**

原因很简单。假设您有10个网站都在同一服务器上以不同IP地址运行。假设站点B进行了一些重大更新，您必须对该站点的配置进行更改。我们也说，所做的更改有问题，因此，当您重新启动httpd以读取新的更改时，httpd不会启动。

您正在工作的站点不仅不会启动，而且其余站点也不会启动。使用这种方法，您可以简单地删除导致失败的站点的符号链接，然后重新启动httpd。它会再次开始工作，您可以开始工作，尝试修复损坏的网站配置。

知道电话不会打断一些生气的客户或生气的老板，这肯定会减轻压力，因为服务是离线的。

###网站配置
这种方法的另一个好处是，它允许我们完全指定默认httpd.conf文件之外的所有内容。让默认的httpd.conf文件加载默认值，然后让您的站点配置执行其他所有操作。亲爱的，对吗？再加上一次，它可以很容易地对损坏的站点配置进行故障排除。

现在，假设您有一个加载Wiki的网站。您将需要一个配置文件，该文件可通过80端口访问该网站。如果您想使用SSL为网站提供服务（让我们面对现实，我们现在都应该这样做），那么您需要添加另一个文件（几乎是相同的） ）部分添加到同一文件，以启用端口443。

因此，我们首先需要在* sites-available *中创建此配置文件：`vi / etc / httpd / sites-available / com.wiki.www`

配置文件的配置内容将如下所示：

阿帕奇
<VirtualHost *：80>
ServerName www.wiki.com
ServerAdmin用户名@ rockylinux.org
Did you mean: DocumentRoot /var/www/subdomains/com.wiki.www/html
DocumentRoot /var/www/sub-domains/com.wiki.www/html
DirectoryIndex index.php index.htm index.html
别名/ icons / / var / www / icons /
Did you mean: # ScriptAlias /cgi-bin/ /var/www/subdomains/com.wiki.www/cgi-bin/
＃ScriptAlias / cgi-bin / /var/www/sub-domains/com.wiki.www/cgi-bin/

CustomLog“ /var/log/httpd/com.wiki.www-access_log”组合
Did you mean: Error_Log "/var/log/httpd/com.wiki.www-error_log"
ErrorLog“ /var/log/httpd/com.wiki.www-error_log”

Did you mean: \u003cDirectory /var/www/subdomains/com.wiki.www/html\u003e
<目录/var/www/sub-domains/com.wiki.www/html>
选项-ExecCGI-索引
AllowOverride无

拒绝订单，允许
全部拒绝
全部允许

满足所有人
</目录>
</ VirtualHost>
```
创建文件后，我们需要使用以下命令写入（保存）：shift：wq

在上面的示例中，Wiki站点是从com.wiki.www的html子目录加载的，这意味着我们在/ var / www中创建的路径（上述）将需要一些其他目录来满足此要求：

Did you mean: `mkdir -p /var/www/subdomains/com.wiki.www/html`
`mkdir -p / var / www / sub-domains / com.wiki.www / html`

...这将使用单个命令创建整个路径。接下来，我们将文件安装到该目录中，该目录将实际运行该网站。这可能是由您或您下载的应用程序（在本例中为Wiki）创建的。将文件复制到上面的路径：

Did you mean: `cp -Rf wiki source/* /var/www/subdomains/com.wikia.www/html/`
cp -Rf wiki_source / * / var / www / sub-domains / com.wiki.www / html /`

##现场直播

请记住，我们的* httpd.conf *文件在文件的末尾包含* / etc / httpd / sites-enabled *，因此，httpd重新启动时，它将加载该* sites-enabled *目录中的所有配置文件。事实是，我们所有的配置文件都位于* sites-available *。

这是设计使然，因此，如果httpd无法重新启动，我们可以轻松删除内容。因此，要启用我们的配置文件，我们需要在* sites-enabled *中创建指向该文件的符号链接，然后启动或重新启动Web服务。为此，我们使用以下命令：

ln -s /etc/httpd/sites-available/com.wiki.www / etc / httpd / sites-enabled /`

就像我们想要的那样，这将在“启用站点”中创建指向配置文件的链接。

现在只需使用systemctl start httpd来启动httpd。或者，如果已经运行，则重新启动它：`systemctl restart httpd`，并假设网络服务重新启动，您现在可以在新站点上进行一些测试。
[x220@ipa01 translate-shell]$
```

# Using opencc for S.C. and T.C. conversion

```
dnf install -y opencc
```
## python version

```
pip3  install opencc-python-reimplemented
```

## convert TC demo text into SC

```
 python3 -m opencc -c t2s -i demo-opencc-origin.tc.md -o demo-opencc-origin.sc.md
```

## convert SC to TC

```
 python3 -m opencc -c s2t -i apache-sites-enabled.yangxuan.sc.md -o apache-sites-enabled.opencc.sc.md
```
