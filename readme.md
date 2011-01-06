croner
======

notes
-----
* still running on my cloudant, should use the addons instead if staying with couch
* that said, no reason to stick with couch, probably should be migrated to just redis
* RunAppCron.perform should be refactored into a method on App
* App#retry should use exponential backoff
