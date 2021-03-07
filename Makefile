VERSION		= 1.6.3
RELEASE		= 2
DATE		= $(shell date)
NEWRELEASE	= $(shell echo $$(($(RELEASE) + 1)))
TOPDIR = $(shell pwd)
DIRS	= profiles_api profiles_project
A2PS2S1C  = /bin/a2ps --sides=2 --medium=Letter --columns=1 --portrait --line-numbers=1 --font-size=8
A2PSTMP   = /tmp
DOCS      = ./docs

SHELL := /bin/bash
#TRANS = ~/.local/bin/translate
#TRANS2 = /home/x220/github/translate-shell/translate
TRANS = /usr/bin/trans
TRANS2 = /usr/bin/trans

DIA=/usr/bin/dia --nosplash --export=/tmp/t.png inplace-workflow.dia


# enable makefile to accept argument after command
#https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`
%:
	@:

all: help

versionfile:
	echo "version:" $(VERSION) > etc/version
	echo "release:" $(RELEASE) >> etc/version
	echo "source build date:" $(DATE) >> etc/version


clean_hard:
	-rm -rf $(shell $(PYTHON) -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")/adagios 

clean_hardest: clean_rpms

#Ref: https://stackoverflow.com/questions/1490949/how-to-write-loop-in-a-makefile
# MANIFEST  
SRC1= Makefile README.md
SRC2= README.cat.md
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
	git commit -am "$(call args, Automated commit message without details, Please read the code difference)"  && git push

sc2tc: sc2tc01

sc2tc01:
	${TRANS}  "服务器多站点设置" -d zh-tw -s zh-cn
tc2sc:
	@echo "Simplified Chinese to Traditonal Chinese"
sc2tc:
	@echo "Traditonal Chinese to Simplified Chinese"

demo: sc2tc01 file01 guide-1-3-chinese guide-1-3-japanese
	@echo
file01:
	${TRANS2} file://./stage/greet.txt :zh-tw
	${TRANS2} file://./stage/greet.txt :zh-cn

guide-1-3-chinese:
	${TRANS2} file://./docs-style-guide/sample-documentation/advanced-docs.md   :zh-tw 
	${TRANS2} file://./docs-style-guide/sample-documentation/beginner-docs.md   :zh-cn
	${TRANS2} file://./docs-style-guide/sample-documentation/simplified-docs.md :zh-cn

guide-1-3-japanese:
	${TRANS2} file://./docs-style-guide/sample-documentation/advanced-docs.md   :jp
#	${TRANS2} file://./docs-style-guide/sample-documentation/beginner-docs.md   :jp
#	${TRANS2} file://./docs-style-guide/sample-documentation/simplified-docs.md :jp
trans-ver:
	${TRANS2} -V
testcmds:
	@which opencc
	@which translate

with-dia:
	@which dia

help:
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets are:"
	@echo "  help                   show this text"
	@echo "  clean                  clean the mess"
	@echo "  sc2tc01                demostrate S.C. to T.C."
	@echo "  demo                   lint source code"
	@echo "  commit                 git commit with default message"
	@echo "  commit my-message      git commit with my message"
	@echo "  test                   lint source code and run tests"
	@echo "  test_no_lint           run tests without linting the source code"
	@echo ""
	@echo "Targets test, lint and test_no_lint support environment variables ACTOR and"
	@echo "TEST_LIBS."
	@echo "If ACTOR=<actor> is specified, targets are run against the specified actor."
	@echo "If TEST_LIBS=y is specified, targets are run against shared libraries."
	@echo ""
	@echo ""
	@echo "Possible use:"
	@echo "  make <target>"
	@echo "  PR=5 make <target>"
	@echo "  MR=6 make <target>"
	@echo "  PR=7 SUFFIX='my_additional_suffix' make <target>"
	@echo "  MR=6 COPR_CONFIG='path/to/the/config/copr/file' make <target>"
	@echo "  ACTOR=<actor> TEST_LIBS=y make test"
	@echo ""

clean:
	@echo "--- Clean repo ---"
	@rm -rf packaging/{sources,SRPMS,tmp}/
	@rm -rf build/ dist/ *.egg-info .pytest_cache/
	@find . -name 'leapp.db' | grep "\.leapp/leapp.db" | xargs rm -f
	@find . -name '__pycache__' -exec rm -fr {} +
	-rm -rf dist/ build/
	-rm -rf *~
	-find . -type f -name *.pyc -exec rm -f {} \;
	-find . -type f -name *~  -exec rm -f {} \;

