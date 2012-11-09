#!/bin/sh

mysql -v --user root -e "drop database voebb; create database voebb;" && mysql --user root voebb < initialize.sql 

