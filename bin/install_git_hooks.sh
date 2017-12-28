#!/bin/bash
#
# Downloads git hooks from https://github.com/drwahl/puppet-git-hooks to control/.git_hooks and copies them into control/.git/hooks/
#
repo_dir=$(git rev-parse --show-toplevel)
. "${repo_dir}/bin/functions"

hooks_repo='https://github.com/drwahl/puppet-git-hooks'
if [ $1 ]; then
  hooks_repo=$1
fi

main_dir=$(git rev-parse --show-toplevel)

echo_title "Executing: git clone ${hooks_repo} ${main_dir}/.git_hooks"
git clone ${hooks_repo} "${main_dir}/.git_hooks"

echo_title "Copying ${main_dir}/.git_hooks/commit_hooks in ${main_dir}/.git/hooks"
cp -rvpn ${main_dir}/.git_hooks/commit_hooks "${main_dir}/.git/hooks"

echo_title "Copying ${main_dir}/.git_hooks//pre-commit in ${main_dir}/.git/hooks"
cp -rvpn ${main_dir}/.git_hooks/pre-commit "${main_dir}/.git/hooks"

echo
echo_subtitle "Installed hooks from ${hooks_repo} to ${main_dir}/.git/hooks"
echo
echo "They will be used on git operations. Mostly in the pre-commit phase"

echo_title "Configure the tests to run hooks by editing ${main_dir}/.git/hooks/commit_hooks/config.cfg"
echo "You may prefer to set CHECK_PUPPET_LINT='permissive' to avoid commit block on Puppet lint errors"

