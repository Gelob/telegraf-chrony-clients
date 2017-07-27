#!/bin/bash
host=$(hostname)
CMD="$(chronyc -a -n clients | wc -l)"

echo chrony,host=$host clients=$CMD
