VERSION		= 1.6.3
RELEASE		= 2
DATE		= $(shell date)
NEWRELEASE	= $(shell echo $$(($(RELEASE) + 1)))
TOPDIR = $(shell pwd)
DIRS	= profiles_api profiles_project
A2PS2S1C  = /bin/a2ps --sides=2 --medium=Letter --columns=1 --portrait --line-numbers=1 --font-size=8
A2PSTMP   = ./tmp
DOCS      = ./docs

SHELL := /bin/bash
TRANS = ~/.local/bin/translate
TRANS2 = /home/x220/github/translate-shell/translate
DIA=/usr/bin/dia --nosplash --export=/tmp/t.png inplace-workflow.dia
all: sc2tc
# enable makefile to accept argument after command
#https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
%:
	@:

versionfile:
	echo "version:" $(VERSION) > etc/version
	echo "release:" $(RELEASE) >> etc/version
	echo "source build date:" $(DATE) >> etc/version

clean: cleantmp
	-rm -rf dist/ build/
	-rm -rf *~
	-find . -type f -name *.pyc -exec rm -f {} \;
	-find . -type f -name *~  -exec rm -f {} \;

clean_hard:
	-rm -rf $(shell $(PYTHON) -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")/adagios 

clean_hardest: clean_rpms

#Ref: https://stackoverflow.com/questions/1490949/how-to-write-loop-in-a-makefile
# MANIFEST  
SRC1= Makefile reqirements.txt restapi-readme.md 
SRC2= manage.py 
#SRC2= manage.py profiles_projects-dir-layout.txt

cleantmp:
	rm -f ${A2PSTMP}/*.ps ${A2PSTMP}/*.pdf	
ps: cleantmp
	$(foreach var, $(SRC1), ${A2PS2S1C} $(var) --output=${A2PSTMP}/$(var).ps ;)
	$(foreach var, $(SRC2), ${A2PS2S1C} $(var) --output=${A2PSTMP}/$(var).ps ;)

pdf: ps
	$(foreach var, $(SRC1), (cd ${A2PSTMP};ps2pdf $(var).ps $(var).pdf);)
	$(foreach var, $(SRC2), (cd ${A2PSTMP};ps2pdf $(var).ps $(var).pdf);)
	rm -f ${A2PSTMP}/*.ps
	cp ${A2PSTMP}/*.pdf  ${DOCS}/

tree: clean
	tree -L 4 > ${PROJECT_NAME}-dir-layout.txt
status:
	git status
commit:
	git commit -am "$(call args, Automated lazy commit message without details, read the code change)"  && git push

sc2tc: sc2tc01

sc2tc01:
	${TRANS}  "服务器多站点设置" -d zh-tw -s zh-cn
tc2sc:
	@echo "Simplified Chinese to Traditonal Chinese"
sc2tc:
	@echo "Traditonal Chinese to Simplified Chinese"

demo: sc2tc01 file01
	@echo
file01:
	${TRANS2} file://./stage/greet.txt :zh-tw
	${TRANS2} file://./stage/greet.txt :zh-cn

trans-ver:
	${TRANS2} -V
testcmds:
	@which opencc
	@which translate

with-dia:
	@which dia
