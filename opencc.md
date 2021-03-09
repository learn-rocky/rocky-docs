
# Using opencc library for Simplified Chinese and Traditional Chinese conversion

opencc is very good at handling Simplified Chinese and Traditional Chinese conversion.

* Install opencc library first.

```
[me@fedora01t rocky-docs]$ sudo dnf install -y opencc 
```

* Then opencc python front end.

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
