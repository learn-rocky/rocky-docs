# Overview
## WHAT: Use C.A.T. to help  Rocky document translation.

This guide is for using C.A.T. software to pre-process source language into a raw destination laguage.
Raw text still need to be reviewed and corrected by human translator.
Rocky document translator decides which approaches is best for their case.

* Direct human translation path.


```
Human writer --> a.txt --> Human Brain --> a.final.txt
```

* Computer Assisted Translation path.


```
Human writer --> a.txt --> CAT --> a.cat.txt--> Human Brain --> a.final.txt
```

## WHY:

* Save time in most case if using good tranlation engine.
* Automating repeatable translation tasks as much as possible


## Tools used in this doc

* Google translate shell, a command line via translate.google.com API.
* opencc : for conversion between SC and zh-tw.

## OS info
```
[me@fedora01t ~]$ lsb_release  -a
LSB Version:	:core-4.1-amd64:core-4.1-noarch
Distributor ID:	Fedora
Description:	Fedora release 34 (Thirty Four)
Release:	34
Codename:	ThirtyFour
[me@fedora01t ~]$ 
```

## Using google translate command line tool


* Install python googletrans version 3.1.0a0

```
pip3 install googletrans==3.1.0a0
```
* translate help 
```

[me@fedora01t bin]$ which translate
~/.local/bin/translate
[me@fedora01t bin]$ ~/.local/bin/translate -h
usage: translate [-h] [-d DEST] [-s SRC] [-c] text

Python Google Translator as a command-line tool

positional arguments:
  text                  The text you want to translate.

optional arguments:
  -h, --help            show this help message and exit
  -d DEST, --dest DEST  The destination language you want to translate. (Default: en)
  -s SRC, --src SRC     The source language you want to translate. (Default: auto)
  -c, --detect
[me@fedora01t bin]$
	
```

# Usage examples

* Example 1: Translate Latin text to English.

```
[me@fedora01t rocky-docs]$ trans "veritas lux mea" -s la -d en
veritas lux mea

The truth is my light

Translations of veritas lux mea
[ Latina -> English ]
[me@fedora01t rocky-docs]$ 
```

## Translate string of text from  SC to English

```
[me@fedora01t bin]$ ./translate -s zh-cn -d zh-tw  "服务器多站点设置"
[zh-CN] 服务器多站点设置
    ->
[zh-tw] 服務器多站點設置
[pron.] Fúwùqì duō zhàn diǎn shèzhì
[me@fedora01t bin]$
```

## Translate string of text from  zh-cn to zh-tw

```
[me@fedora01t rocky-docs]$ trans  "服务器多站点设置" -d zh-tw
[zh-CN] 服务器多站点设置
    ->
[zh-tw] 服務器多站點設置
[pron.] Fúwùqì duō zhàn diǎn shèzhì
[me@fedora01t rocky-docs]$ 
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
[me@fedora01t rocky-docs]$ make file01
 /home/me/github/translate-shell/translate file:///home/me/github/rocky-docs/greet.txt :zh-tw
 [ERROR] Google did not return results because rate limiting is in effect
 [ERROR] Rate limiting
[me@fedora01t rocky-docs]$
```
* Translate text in file examples.
```

[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :zh-tw
你好。你好吗？
[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :zh-cn
你好。你好吗？
[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :ja
こんにちは。お元気ですか？
[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :en
Hello. How are you?
[me@fedora01t rocky-docs]$

```

### Now translate rocky howto guides to  ZH-TW language

Following is returning zh-cn characters, not zh-tw as specified.

```
[me@fedora01t ]$ trans file:///home/me/github/rocky-docs/apache-sites-enabled.english.md  :zh-tw
---
标题：“ Apache Web服务器多站点设置
---

＃Apache Web服务器多站点设置

Rocky Linux提供了许多方法来设置网站。这只是使用Apache的一种方法，旨在用作单个服务器上的多站点设置。<snipped>

历史事实：此服务器设置似乎是从基于Debian的系统开始的，但它完全适合于任何运行Apache的Linux操作系统。

##您需要什么
*运行Rocky Linux的服务器
*命令行和文本编辑器的知识（此示例使用* vi *，但可以适应您喜欢的编辑器。）
*如果您想了解vi文本编辑器，请[这里是一个方便的教程]（https://www.tutorialspoint.com/unix/unix-vi-editor.htm）。
*有关安装和运行Web服务的基本知识

<snipped>

[me@fedora01t ]$

```

# Using opencc library for S.C. and T.C. conversion

```
sudo dnf install -y opencc
```

## opencc python front end

```
pip3  install opencc-python-reimplemented
```

## convert zh-tw file into zh-cn


```
 python3 -m opencc -c t2s -i /home/me/github/rocky-docs/stage/demo-opencc-origin.tc.md -o /tmp/demo-opencc-origin.sc.md
```

## convert zh-cn to zh-tw

```
 python3 -m opencc -c s2t -i /home/me/github/rocky-docs/stage/demo-opencc-origin.sc.md -o /tmp/demo-opencc-origin.tc.md
```

# References:
* opencc
* opencc-python-reimplemented
* https://en.wikipedia.org/wiki/Computer-assisted_translation
