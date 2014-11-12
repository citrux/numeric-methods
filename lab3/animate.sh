#!/bin/bash
convert -delay 10 ${@:2} -loop 1 $1
