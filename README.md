# Skeletra [![Build Status][travis-image]][travis-link]

[travis-image]: https://secure.travis-ci.org/carlzulauf/redis-types.png?branch=master
[travis-link]: http://travis-ci.org/carlzulauf/redis-types

Skeleton single-process sinatra app.

Goals/features:

* Small and lightweight
* Single-process
  * Web requests and background work run together in same process
  * Slow or persistent background jobs don't block web requests
* Functional asset pipeline with coffeescript support
* Haml and SCSS, by default
* Test coverage
* Portable, but JRuby first. MRI and Rubinius second.
