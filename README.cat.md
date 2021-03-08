# Assisted translation overview
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
* opencc : for conversion between SC and zh-TW.

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

# Examples from translate

* Example 1: Translate Latin text to English.

```
[me@fedora01t rocky-docs]$ trans "veritas lux mea" -s la -d en 
veritas lux mea

The truth is my light

Translations of veritas lux mea
[ Latina -> English ]
[me@fedora01t rocky-docs]$
[me@fedora01t rocky-docs]$ ~/.local/bin/translate "veritas lux mea" -s la -d ja
[la] veritas lux mea
    ->
[ja] 真実は私の光です
[pron.] Shinjitsu wa watashi no hikaridesu
[me@fedora01t rocky-docs]$ ~/.local/bin/translate "veritas lux mea" -s la -d zh-TW
[la] veritas lux mea
    ->
[zh-TW] 事實是我的光
[pron.] Shìshí shì wǒ de guāng
[me@fedora01t rocky-docs]$ ~/.local/bin/translate "veritas lux mea" -s la -d zh-CN
[la] veritas lux mea
    ->
[zh-CN] 事实是我的光
[pron.] Shìshí shì wǒ de guāng
[me@fedora01t rocky-docs]$ 
```

## Translate string of text from  SC to English

```
[me@fedora01t bin]$ ./translate -s zh-CN -d zh-TW  "服务器多站点设置"
[zh-CN] 服务器多站点设置
    ->
[zh-TW] 服務器多站點設置
[pron.] Fúwùqì duō zhàn diǎn shèzhì
[me@fedora01t bin]$
```

## Translate string of text from  zh-CN to zh-TW

```
[me@fedora01t rocky-docs]$  trans  "服务器多站点设置" :zh-TW
服务器多站点设置
(Fúwùqì duō zhàndiǎn shèzhì)

服務器多站點設置
(Fúwùqì duō zhàn diǎn shèzhì)
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

## Default backend is google translate engine with rate limitation. 

### you may see following error message which usage is reached.
```
[me@fedora01t rocky-docs]$ make file01
 /home/me/github/translate-shell/translate file:///home/me/github/rocky-docs/greet.txt :zh-TW
 [ERROR] Google did not return results because rate limiting is in effect
 [ERROR] Rate limiting
[me@fedora01t rocky-docs]$
```
* Translate greeting  text in file to other languages.
```
[me@fedora01t ]$ cat /home/me/github/rocky-docs/stage/greet.txt
வணக்கம். எப்படி இருக்கீங்க?
[me@fedora01t ]$
[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :zh-TW
你好。你好嗎？
[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :zh-CN
你好。你好吗？
[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :ja
こんにちは。お元気ですか？
[me@fedora01t rocky-docs]$ trans  file:///home/me/github/rocky-docs/stage/greet.txt  :en
Hello. How are you?
[me@fedora01t rocky-docs]$
```

### Now translate rocky howto guides to  ZH-TW language

Following is returning zh-CN characters, not zh-TW as specified.

```

[me@fedora01t rocky-docs]$  trans file:///home/me/github/rocky-docs/stage/apache-sites-enabled.english.md  :zh-TW | head -20
---
標題：“ Apache Web服務器多站點設置”
---

＃Apache Web服務器多站點設置

Rocky Linux提供了許多方法來設置網站。這只是使用Apache的一種方法，旨在用作單個服務器上的多站點設置。儘管此方法是為多站點服務器設計的，但它也可以作為單個站點服務器的基本配置。

歷史事實：此服務器設置似乎已從基於Debian的系統開始，但它完全適用於任何運行Apache的Linux操作系統。

##您需要什麼
*運行Rocky Linux的服務器
*命令行和文本編輯器的知識（此示例使用* vi *，但可以適應您喜歡的編輯器。）
*如果您想了解vi文本編輯器，請[這裡是一個方便的教程]（https://www.tutorialspoint.com/unix/unix-vi-editor.htm）。
*有關安裝和運行Web服務的基本知識

##安裝Apache
您可能需要網站的其他軟件包。例如，幾乎肯定會需要一個PHP版本，也許還需要一個數據庫或其他軟件包。將PHP與httpd一起安裝將使您從Rocky Linux存儲庫中獲得最新版本。

請記住，您可能還需要模塊，例如php-bcmath或php-mysqlind。您的Web應用程序規範應詳細說明所需的內容。這些可以隨時安裝。現在，我們將安裝httpd和PHP，因為它們幾乎已成定局：
  C-c C-c
  <snipped>
[me@fedora01t rocky-docs]$ 
```

# Using opencc library for Simplified Chinese and Traditional Chinese conversion

```
[me@fedora01t rocky-docs]$ sudo dnf install -y opencc 
```

## opencc python front end

```
pip3  install opencc-python-reimplemented
```

## convert zh-TW file into zh-CN


```
 python3 -m opencc -c t2s -i /home/me/github/rocky-docs/stage/demo-opencc-origin.tc.md -o /tmp/demo-opencc-origin.sc.md
```

## convert zh-CN to zh-TW

```
 python3 -m opencc -c s2t -i /home/me/github/rocky-docs/stage/demo-opencc-origin.sc.md -o /tmp/demo-opencc-origin.tc.md
```

# References:
* translate-shell: https://github.com/soimort/translate-shell
* opencc
* opencc-python-reimplemented
* https://en.wikipedia.org/wiki/Computer-assisted_translation
