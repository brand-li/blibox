.. include:: /_includes/all.rst
.. include:: /_includes/snippets/__ANNOUNCEMENTS__.rst

.. _source_code_analysis:

********************
Source Code Analysis
********************

This tutorial gives you a general overview how to do static code analysis from within the PHP
container.

.. seealso::
   * :ref:`available_tools`
   * :ref:`work_inside_the_php_container`


**Table of Contents**

.. contents:: :local:


Awesome-ci
==========

Awesome-ci is a collection of tools for analysing your
workspace and its files. You can for example check for:

* git conflicts
* git ignored files that have not been removed from the git index
* trailing spaces and newlines
* non-utf8 files or utf8 files with bom
* windows line feeds
* null-byte characters
* empty files
* syntax errors for various languages
* inline css or js code
* customized regex

Some of the bundled tools even allow for automatic fixing.

.. seealso:: |ext_lnk_tool_awesome_ci|

.. code-block:: bash

   # 1. Enter your PHP container
   host> ./bash

   # 2. Go to your project folder
   blibox@php-7.0.20 $ cd /shared/httpd/my-project

   # 3. Run the tools
   blibox@php-7.0.20 $ git-conflicts --path=.
   blibox@php-7.0.20 $ git-ignored --path=.
   blibox@php-7.0.20 $ file-cr --path=.
   blibox@php-7.0.20 $ file-crlf --path=.
   blibox@php-7.0.20 $ file-empty --path=.

   # 4. Run tools with more options
   blibox@php-7.0.20 $ syntax-php --path=. --extension=php
   blibox@php-7.0.20 $ syntax-php --path=. --shebang=php

   # 5. Various syntax checks
   blibox@php-7.0.20 $ syntax-bash --path=. --text --extension=sh
   blibox@php-7.0.20 $ syntax-css --path=. --text --extension=css
   blibox@php-7.0.20 $ syntax-js --path=. --text --extension=js
   blibox@php-7.0.20 $ syntax-json --path=. --text --extension=json
   blibox@php-7.0.20 $ syntax-markdown --path=. --text --extension=md
   blibox@php-7.0.20 $ syntax-perl --path=. --text --extension=pl
   blibox@php-7.0.20 $ syntax-php --path=. --text --extension=php
   blibox@php-7.0.20 $ syntax-python --path=. --text --extension=python
   blibox@php-7.0.20 $ syntax-ruby --path=. --text --extension=rb
   blibox@php-7.0.20 $ syntax-scss --path=. --text --extension=scss


PHPCS
=====

PHPCS is a code style analyser for PHP.

.. seealso:: |ext_lnk_tool_phpcs|

.. code-block:: bash

   # 1. Enter your PHP container
   host> ./bash

   # 2. Go to your project folder
   blibox@php-7.0.20 $ cd /shared/httpd/my-project

   # 3. Run it
   blibox@php-7.0.20 $ phpcs .


ESLint
======

ESLint is a Javascript static source code analyzer.

.. seealso:: |ext_lnk_tool_eslint|

.. code-block:: bash

   # 1. Enter your PHP container
   host> ./bash

   # 2. Go to your project folder
   blibox@php-7.0.20 $ cd /shared/httpd/my-project

   # 3. Run it
   blibox@php-7.0.20 $ eslint .
