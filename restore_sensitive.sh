#!/bin/bash

# remove any remaining sensitive files
tar -xzf sensitive.tar.gz
cp sensitive/development.sqlite3 db/
cp sensitive/production.sqlite3 db/
cp sensitive/test.sqlite3 db/

# remove the old system dir
mv system.tar.gz public/
cd public
tar -xzf system.tar.gz