#!/bin/bash
# hack until: https://github.com/roboll/helmfile/issues/766
if [ ! -f $1 ]; then
  echo -n 'false'
else
  echo -n 'true'
fi
