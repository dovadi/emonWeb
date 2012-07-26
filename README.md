emonWeb
=======

**emonWeb** is built with Rails 3.2 and is a port from [emonCMS](http://openenergymonitor.org/emon/node/90) (which is built in php).

**emonCMS** (and therefore **emonWeb** as well) is a powerful open-source web-app for processing, logging and visualising energy, temperature and other environmental data to be used with the [Open Energy Monitor](http://openenergymonitor.org).

The [Open Energy Monitor](http://openenergymonitor.org) is a project to develop and build open-source energy monitoring, control and analysis tools for energy efficiency and distributed renewable microgeneration.

The core team of the [Open Energy Monitor](http://openenergymonitor.org) exists of:

* [Trystan Lea](https://github.com/TrystanLea)
* [Glyn Hudson](https://github.com/glynhudson)
* [and others](http://openenergymonitor.org/emon/people)

Installation
============

EmonWeb is tested with ruby 1.9.3 (for installation with RVM see [Install Ruby Version Manager](http://beginrescueend.com/rvm/install/) )

> git clone git@github.com:dovadi/emonWeb.git

> cd emonWeb

> gem install bundler

> bundle install

> cp config/database.yml.example config/database.yml

> rake db:create

> rake db:migrate

> rails server

## Possible issues ##

* libxml2 is needed to compile the native extension of Nokogiri, see [Installation instructions]( http://nokogiri.org/tutorials/installing_nokogiri.html)


## Project .rvmrc 

See for usage the (.rvmrc instructions)[http://beginrescueend.com/workflow/rvmrc/]

> cp _rvmrc .rvmrc

See the [Wiki](https://github.com/dovadi/emonWeb/wiki) for more explanation or *try it out on [emonWeb.org](http://emonWeb.org) yourself!*

Running Specs
=============

With the use of guard (and Spork):

## OSX ##

> gem install rb-fsevent

> gem install growl_notify


## LINUX ##

> gem install rb-inotify

> gem install libnotify


Contributing to emonWeb
=======================
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Make a pull request

Credits
=======

[Open Energy Monitor](http://openenergymonitor.org) 2012

emonWeb is funded and maintained by [Agile Dovadi BV](http://dovadi.com), contact [Frank Oxener](mailto:frank@dovadi.com)

License
=======

emonWeb is open sourced under the [MIT license](https://github.com/dovadi/emonWeb/blob/master/LICENSE.txt)