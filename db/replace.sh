#!/bin/sh
rm -f soma.db
sqlite soma.db < schema.sql
