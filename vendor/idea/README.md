IntelliJ IDEA Puppet Module
===========================

[![Build Status](https://secure.travis-ci.org/l0b0/puppet-idea.png)](https://travis-ci.org/l0b0/puppet-idea)

Overview
--------

Install IntelliJ IDEA Community or Ultimate Edition from the official vendor site.


Usage
-----

Example:

    class { 'idea::ultimate':
      version => '12.0.1',
    }


Test
----

    rvm use 2.3.0 --install # Or whatever version of Ruby
    bundle install
    bundle exec rake

License
-------

Copyright (c) 2012 - 2014 Gini GmbH, 2015 - 2016 Victor Engmark

This script is licensed under the Apache License, Version 2.0.

See http://www.apache.org/licenses/LICENSE-2.0.html for the full license text.


Support
-------

Please log tickets and issues at the [project site](https://github.com/l0b0/puppet-idea/issues).
