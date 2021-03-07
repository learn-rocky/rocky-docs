# WHAT: Rocky CAT
* Direct human translation.

```
Human writer --> a.txt --> Human Brain --> a.final.txt
```

* Computer Assisted Translation on Rocky
```
Human writer --> a.txt --> CAT --> a.sat.txt--> Human Brain --> a.final.txt

```


# WHY:
* Save time in most case if using good tranlation engine.
* Automating  repeatable tasks as much as possible


# Tools used in this doc

* Google translate shell: from English to other languages.
* opencc : for conversion between SC and TC.


# Using google translate command line tool

## install

```
pip3 install googletrans==3.1.0a0
```
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

## Install translate-shell
```
sudo dnf install -y translate-shell
```
## trans version info
```
[me@fedora01t sample-documentation]$ trans --version
Translate Shell       0.9.6.12

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
[me@fedora01t sample-documentation]$ 

```

## default using google translate engine (beware of transaltion rate limit)

### you may see following error message which usage is reached.
```
[x220@ipa01 rocky-docs]$ make file01
   /home/x220/github/translate-shell/translate file:///home/x220/github/rocky-docs/greet.txt :zh-tw
   [ERROR] Google did not return results because rate limiting is in effect
   [ERROR] Rate limiting

   [x220@ipa01 rocky-docs]$
```

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

<snipped>

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

# References:
* https://en.wikipedia.org/wiki/Computer-assisted_translation
