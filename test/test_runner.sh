#!/bin/sh
mocha --reporter landing --compilers coffee:coffee-script --require test/test_helper.js
