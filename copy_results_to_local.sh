if [ -z "${USERNAME}" ]; then
  echo "You need to set the environment variable \$USERNAME to your school eid"
  exit 1
fi

if [[ ! -d "vtune_results" ]]; then
  echo "The result directory (./vtune_results) doesn't yet exist, creating it now"
  mkdir -p vtune_results
fi

rsync -a --ignore-existing vtune_results/ $USERNAME@:portal.cs.virginia.edu:/bigtemp/$USERNAME/
