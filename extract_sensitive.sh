#!/bin/bash

mkdir sensitive
cp db/development.sqlite3 sensitive/
cp db/production.sqlite3 sensitive/
cp db/test.sqlite3 sensitive/
tar -czf sensitive.tar.gz sensitive
mv sensitive.tar.gz public/
cd public
tar -czf system.tar.gz system
