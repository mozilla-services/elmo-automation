# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from buildbot.process import factory
from buildbot.steps.shell import ShellCommand
from buildbot.process.properties import WithProperties

from twisted.python import log

from l10ninsp.steps import InspectLocale, ElasticSetup


class Factory(factory.BuildFactory):
    useProgress = False
    logEnviron = False

    def __init__(self, basedir, mastername, steps=None, hg_shares=None):
        factory.BuildFactory.__init__(self, steps)
        self.hg_shares = hg_shares
        self.base = basedir
        self.mastername = mastername

    def newBuild(self, requests):
        steps = self.createSteps(requests[-1])
        b = self.buildClass(requests)
        b.useProgress = self.useProgress
        b.setStepFactories(steps)
        return b

    def createSteps(self, request):
        elastic = ((ElasticSetup, {}),)
        properties = request.properties
        revs = properties['revisions']
        if revs is None:
            revs = ['en', 'l10n']
            log.msg('no revisions given in ' + str(properties))
        else:
            revs = revs[:]
        tree = properties['tree']
        hg_workdir = self.base
        shareSteps = tuple()
        hg = ['hg']
        if self.hg_shares is not None:
            hg_workdir = self.hg_shares
            shareSteps = tuple(
                (ShellCommand, {
                    'command': [
                        'mkdir', '-p', properties[mod + '_branch']],
                    'workdir': hg_workdir,
                    'logEnviron': self.logEnviron
                })
                for mod in revs) + tuple(
                (ShellCommand, {
                    'command': hg + [
                        'share', '-U',
                        '{}/{}'.format(self.base, properties[mod + '_branch']),
                        properties[mod + '_branch']],
                    'workdir': hg_workdir,
                    'flunkOnFailure': False,
                    'logEnviron': self.logEnviron
                })
                for mod in revs)
        sourceSteps = tuple(
            (ShellCommand, {'command':
                            hg + ['update', '-C', '-r',
                                  properties[mod + '_revision']],
                            'workdir': '{}/{}'.format(
                                hg_workdir,
                                properties[mod + '_branch']
                            ),
                            'haltOnFailure': True,
                            'logEnviron': self.logEnviron})
            for mod in revs)
        redirects = {}
        for key, value, src in properties.asList():
            if key.startswith('local_'):
                redirects[key[len('local_'):]] = value
        inspectSteps = (
            (InspectLocale, {
                    'master': self.mastername,
                    'workdir': hg_workdir,
                    'inipath': properties['inipath'],
                    'l10nbase': properties['l10nbase'],
                    'redirects': redirects,
                    'locale': properties['locale'],
                    'tree': tree,
                    }),)
        return elastic + shareSteps + sourceSteps + inspectSteps
