# docs
Using opencc for S.C. and T.C. conversion

## opencc

dnf install -y opencc

pip3  install opencc-python-reimplemented

# convert TC demo text into SC
 python3 -m opencc -c t2s -i demo-opencc-origin.tc.md -o demo-opencc-origin.sc.md

# convert SC to TC
 python3 -m opencc -c s2t -i apache-sites-enabled.yangxuan.sc.md -o apache-sites-enabled.opencc.sc.md

# Using google translate command line tool
 pip3 install googletrans==3.1.0a0

[x220@ipa01 py-googletrans]$ translate "veritas lux mea" -s la -d en
[la] veritas lux mea
    ->
    [en] The truth is my light
    [pron.] The truth is my light
[x220@ipa01 py-googletrans]$
 
