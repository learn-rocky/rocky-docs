春風又綠江南岸# Assisted translation overview
## WHAT: Using C.A.T. software with makefile

This guide is to utilize recent C.A.T. software for pre-processing language text into destination laguage.
The translated language will need to be further reviewed  human tranlator.
Rocky document translators decide which approaches is best for their case.

* Direct human translation path.

```
Human writer --> a.txt --> Human Brain --> a.final.txt
```

* Computer Assisted Translation path.

```
Human writer --> a.txt --> C.A.T. software --> a.cat.txt--> Human Brain --> a.final.txt
```

## WHY:

* Many repetitive translation tasks can be acclerated  by automation using makefile.
* Less stressful when you can off-load tasks to compute macihne.

## Tools used in this doc

* Google translate shell, a command line via translate.google.com API.
* GNU Make, for task automation.
* Dia, for authoring digrams to condense meanings into picture.
* Git/Github, distributed sourcecode/text  management tool for a group.

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

# Using google translate command line tool, trans

## Examples from trans tool

* Example 1: Translate Latin text to English.

```
[me@fedora01t rocky-docs]$ trans "veritas lux mea"  la:en 
veritas lux mea

The truth is my light

Translations of veritas lux mea
[ Latina -> English ]
[me@fedora01t rocky-docs]$
```

* Example 2: latin to japanese

```
[me@fedora01t rocky-docs]$ trans "veritas lux mea" la:ja
veritas lux mea

真実は私の光です
(Shinjitsu wa watashi no hikaridesu)

Translations of veritas lux mea
[ Latina -> 日本語 ]

veritas lux mea
    真実は私の光です, 真実は、私の光であり、
[me@fedora01t rocky-docs]$ 

```

*Example 3:  Text translated from Simplified Chinese(zh-CN) to Tranditional Chinese.

```
[me@fedora01t bin]$ trans zh-CN:zh-TW  "服务器多站点设置"
[zh-CN] 服务器多站点设置
    ->
[zh-TW] 服務器多站點設置
[pron.] Fúwùqì duō zhàn diǎn shèzhì
[me@fedora01t bin]$

```

*Example 4: Need human anslated from Simplified Chinese(zh-CN) to Tranditional Chinese.

```
[me@fedora01t rocky-docs]$ trans --brief zh-TW:en  "春風又綠江南岸"
Spring breeze and green south bank of the river
春     風     又  綠    南    岸          江
[me@fedora01t rocky-docs]$

```
* Better translation of "春風又綠江南岸" by human brain.
```
"春風又綠江南岸" --> "Spring bring burgeoning green plant lift to southern China."
```

## Default trans backend is google translate engine with rate limit.

### Example output when free usage threshhold is reached.
```
[me@fedora01t rocky-docs]$ make file01
 /home/me/github/translate-shell/translate file:///home/me/github/rocky-docs/greet.txt :zh-TW
 [ERROR] Google did not return results because rate limiting is in effect
 [ERROR] Rate limiting
[me@fedora01t rocky-docs]$

[me@fedora01t rocky-docs]$ trans --dump ...
<snipped>
<div style="font-size:13px;">
Our systems have detected unusual traffic from your computer network.
Please try your request again later.
<a href="#" onclick="document.getElementById('infoDiv0').style.display='block';">Why did this happen?</a><br><br>
<snipped>
[me@fedora01t rocky-docs]$

```

* Translate greeting text in file to other languages.

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

## Translate Rocky Howto Guides to zh-TW by trans.

Following example may not finish the whole file translation if usage from your IP reach the limit.

```

[me@fedora01t rocky-docs]$trans file:///home/me/github/rocky-docs/stage/apache-sites-enabled.english.md  :zh-TW | head -20
---
標題：“ Apache Web服務器多站點設置”
---

＃Apache Web服務器多站點設置

Rocky Linux提供了許多方法來設置網站。這只是使用Apache的一種方法，旨在用作單個服務器上的多站點設置。
儘管此方法是為多站點服務器設計的，但它也可以作為單個站點服務器的基本配置。

歷史事實：此服務器設置似乎已從基於Debian的系統開始，但它完全適用於任何運行Apache的Linux操作系統。


  C-c C-c
  <snipped>
[me@fedora01t rocky-docs]$ 
```

# Automate the translation task by makefile
## TBC

* Example makefile

```
TBC
```

* automake your git commit by make
```
make commit                    # no argument will commit with default message text.
make commit "testing message"  # adding commit message
```

* t02

```
TBC
```

# References
* R1: translate-shell,https://github.com/soimort/translate-shell
   * More trans examples at https://github.com/soimort/translate-shell/blob/develop/README.md
* R2: https://en.wikipedia.org/wiki/Computer-assisted_translation
