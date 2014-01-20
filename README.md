# Skeletra [![Build Status][travis-image]][travis-link]

[travis-image]: https://secure.travis-ci.org/carlzulauf/skeletra.png?branch=master
[travis-link]: http://travis-ci.org/carlzulauf/skeletra

Skeleton single-process sinatra app.

## Goals/features:

* Small and lightweight
* Single-process
  * Web requests and background work run together in same process
  * Slow or persistent background jobs don't block web requests
* Functional asset pipeline with coffeescript support
* Haml and SCSS, by default
* Test coverage
* Portable: JRuby, Rubinius, and MRI all supported and tested.

## Install

Fork this repo. Clone to your local machine. Run bundler.

    git clone git@github.com:carlzulauf/skeletra my-project-name
    cd my-project-name
    bundle install

## Use

### Make the project your own

Replace all references to `Skeletra` with your own project name.

    rake rename NAME=MyProject

### Run specs

Make sure you haven't broken anything

    rake spec

### Run server

Use `rackup` or `puma` commands to start the server.

    $ rackup
    Puma 2.7.1 starting...
    * Min threads: 0, max threads: 16
    * Environment: development
    * Listening on tcp://0.0.0.0:9292

Check out the default page and project layout.

## Develop

Add your code. Add your specs. Iterate.
