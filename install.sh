#!/bin/bash

while [ 1 ]
do
  ./scripts/feeds update -a
  ./scripts/feeds install -a
done
