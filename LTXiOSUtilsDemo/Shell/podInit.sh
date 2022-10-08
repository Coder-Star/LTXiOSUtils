# 是否是git repo
RESULT=$(git rev-parse --is-inside-work-tree 2>&1)
if [ "${RESULT}" = "true" ]; then
    git config core.hooksPath .git-hooks
fi
