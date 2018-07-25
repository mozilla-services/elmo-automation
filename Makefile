# makefile to help with stage creation and general set up

setup:: vendor-local/elmo
setup:: stage/venv workdirs stage/repos

VCT ?= ~/.mozbuild/version-control-tools

# virtualenv to be used to commit and push in the working dir
stage/venv:
	virtualenv stage/venv
	./stage/venv/bin/pip install mercurial==4.5.3
	mkdir -p stage/venv/etc/mercurial/hgrc.d
	echo "$$HGRC" > stage/venv/etc/mercurial/hgrc.d/hgmo.rc

define HGRC
[extensions]
pushlog = $(VCT)/hgext/pushlog
endef

export HGRC

# upstream mercurial repos and downstream ones
stage/repos:
	mkdir -p stage/repos

.PHONY: workdirs
workdirs:: stage/workdir/mozilla
workdirs:: stage/workdir/l10n/ab
workdirs:: stage/workdir/l10n/de
workdirs:: stage/workdir/l10n/ja-JP-mac
workdirs:: stage/workdir/l10n/x-testing

stage/workdir/%: stage/hgmo/%
	mkdir -p stage/workdir/$(dir $*)
	hg --cwd stage/workdir/$(dir $*) clone $(PWD)/stage/hgmo/$*

.PRECIOUS: stage/hgmo/%
stage/hgmo/%:
	mkdir -p stage/hgmo/$(dir $*)
	hg init stage/hgmo/$*

content-en-US: stage/workdir/mozilla stage/workdir/mozilla/browser/locales/l10n.ini

stage/workdir/mozilla/browser/locales/l10n.ini: AB_CD=en-US
stage/workdir/mozilla/browser/locales/l10n.ini: stage/venv/bin/hg
	mkdir -p stage/workdir/mozilla/browser/locales/en-US
	echo "$$INI" > stage/workdir/mozilla/browser/locales/l10n.ini
	echo "$$ALL" > stage/workdir/mozilla/browser/locales/all-locales
	echo "$$PROPS" > stage/workdir/mozilla/browser/locales/en-US/file.properties
	echo "$$DTD" > stage/workdir/mozilla/browser/locales/en-US/second.dtd
	./stage/venv/bin/hg --cwd stage/workdir/mozilla addremove
	./stage/venv/bin/hg --cwd stage/workdir/mozilla ci -m'initial project'
	./stage/venv/bin/hg --cwd stage/workdir/mozilla push

content-l10n-%: AB_CD=$*
content-l10n-%: stage/workdir/l10n/% stage/venv/bin/hg
	mkdir -p stage/workdir/l10n/$(AB_CD)/browser
	echo "$$PROPS" > stage/workdir/l10n/$(AB_CD)/browser/file.properties
	echo "$$DTD" > stage/workdir/l10n/$(AB_CD)/browser/second.dtd
	./stage/venv/bin/hg --cwd stage/workdir/l10n/$(AB_CD) addremove
	./stage/venv/bin/hg --cwd stage/workdir/l10n/$(AB_CD) ci -m'initial translation'
	./stage/venv/bin/hg --cwd stage/workdir/l10n/$(AB_CD) push

define INI
[general]
depth = ../..
all = browser/locales/all-locales

[compare]
dirs = browser
endef
define ALL
de
endef
define PROPS
some_id: $(AB_CD) value
endef
define DTD
<!ENTITY entry "$(AB_CD) value">
endef
export INI ALL PROPS DTD


docker-images:: bb-image a10n-image

bb-image:: base-image
	docker build -t elmo_bb --build-arg shares=/home/app/shares -f bb/Dockerfile .

a10n-image:: base-image
	docker build -t elmo_a10n -f a10n/Dockerfile .

base-image::
	docker build -t local/elmo_base -f base/Dockerfile .
