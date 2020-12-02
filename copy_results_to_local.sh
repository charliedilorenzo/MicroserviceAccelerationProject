#!/bin/bash

if [ -z "${USERNAME}" ]; then
  echo "You need to set the environment variable \$USERNAME to your school eid

  export USERNAME=abc123
"
  exit 1
fi

if [[ ! -d "vtune_results" ]]; then
  echo "The result directory (./vtune_results) doesn't yet exist, creating it now"
  mkdir vtune_results
fi

echo "syncing files ..."
rsync -armvte ssh --ignore-existing --progress $USERNAME@portal.cs.virginia.edu:/bigtemp/$USERNAME/ vtune_results/
