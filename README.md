# Workflows

## Stage all changes to tracked files

```
git add -u
```

## Stage all changes to tracked & untracked files

```
git add -A
```

## Using VSCode to add detailed commit message

If you'd like to write commit messages inside VSCode you can do so by

1. Open your command prompt, `Cmd+Sft+P`
2. Run the _Shell Command: Install 'code' command in PATH_ command.
3. Run `git config --global core.editor code`

Now when you want to write a detailed commit message you can:

1. `git add` your changes
2. Run `git commit` without the `-m` flag. This will open up a `COMMIT_EDITMSG` file
3. Add your commit message to `COMMIT_EDITMSG`
4. Save `Cmd+S`
5. Close the tab to use commit message `Cmd+W`

## The `precommit` script rejected my changes

1. `git commit` runs and encounters a linting error.
2. Change the file(s) the hook rejected.
3. `git add -u`
4. `git commit`

## Standard Development

Let's say you get assigned a linear issue, how do you go about developing?

### Choose a branch name

Use the following branch name structure

```abnf

; Examples
; bug/LOG-123/fix-some-functionality
; feature/LOG-123/add-some-functionality
; hotfix/LOG-123/some-hotfix-description
; perfect-cents/some-random-branch

branch-name =
    branch-prefix
    [ "/" linear-issue ] ; Make sure to reference the linear issue if there is one
    "/" branch-slug ; Use to describe the purpose of the branch

branch-prefix =
    "bug" / ; Use if the issue is a clear-cut bug assigned in linear
    "feature" / ; Use if the issue is modifying functionality
    "hotfix" / ; Use if the issue is a hotfix on a live deployment
    github-username ; Use as a catch all for personal development

github-username = (ALPHA DIGIT) / (ALPHA DIGIT) *(ALPHA DIGIT "-") (ALPHA DIGIT) ; Your github username

branch-slug =
  (ALPHA DIGIT) / ; Numbers and digits
  (ALPHA DIGIT) *(ALPHA DIGIT "-") (ALPHA DIGIT) ; Numbers and digits with no trailing or leading hyphens
```

### Make & push changes

1. `git checkout main`
2. `git checkout -b <branch-name>`
3. Make changes...
4. Suddenly, you need to work on some other code! You can run the following commands to save your progress.
5. `git add -A`
6. `git commit -m 'WIP'`
7. `git checkout some-other-branch`
8. Once you're done, come back...
9. `git checkout <branch-name>`
10. Make more changes...
11. Once you decide to commit & push these changes, run the following command:
12. `git reset --soft main` This will stage all committed changes that haven't been pushed yet, clearing out all of the bad commit messages.
13. Now we can run `git commit`, write a pretty commit message. And we didn't have to do a complex rebase.
14. Once you are happy with your commit(s), i.e. You have good code & good commit messages, run the following command:
15. `git push`, or more likely `git push --set-upstream origin <branch-name>` if it's your first push.

The important thing about this flow is that you do **NOT** push the WIP commits. Our `prepush` hook will ensure that no commit messages matching `/^WIP$/` are pushed. Forcing you to reset and write a pretty commit message.

### Make a PR

Go to github.com and make a PR into `main`. See [Github Documentation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)

Open the PR creation page via the command line:

```sh
gh pr create --base main --web
```

Or create the PR interactively via the command line:

```sh
gh pr create --base main
```

### Make a staging release from PR

Make sure that all CI checks have passed.

Next you can make a special comment on the PR to deploy it to staging. Our CI will pick up that comment and create a release based on that comment.

You can also use the _Saved Reply_ feature inside the PR's comment toolbar to quickly submit builds this way. See [Github Documentation](https://docs.github.com/en/get-started/writing-on-github/working-with-saved-replies/about-saved-replies)

### How to format PR deploy comments?

Deploy all services to production

````yml
```yml
action: Staging Release
services:
  - identity
  - dashboard
  - example
  - hydra-public
  - hydra-admin
slug: some-release-description
title: Release Title
notes: |-
  Some release notes bla bla bla
```
````

Minimally you can supply the following

````yml
```yml
action: Staging Release
services:
  - identity
  - dashboard
  - example
  - hydra-public
  - hydra-admin
title: Release Title
```
````

The `slug` will default to a kebab'd version of the `title`.

### Create a staging release

Run the _Test, build, deploy_ action inside the _Actions_ tab on the PR branch. It will deploy the latest version of the branch.

### Create a production release

Merge your PR into `main`.

Communicate! The `main` branch will not always be perfectly clean.

If the `main` branch is clean, you can run _Test, build, deploy_ action inside the _Actions_ tab.

If it's not clean when you go to deploy (someone else merged in before you got a chance to deploy) you can deploy from a previous commit on the `main` branch.

You can find the commit two ways, manually by looking through `git logs`.

Or via the PR. At the bottom of the PR page there will be a message.

> **username** merged commit 7f5ac59 into `main` 30 minutes ago

Paste the commit hash into the _Test, build, deploy_ action and it will trigger your release from that commit.

### Hotfix code in production

Hotfixes should to patch live functionality. Hotfixes are meant for **production** bugfixes only. If you hotfix staging it will work, but it becomes much harder to track changes this way.

First find the release tag. Go to the releases page: https://github.com/unstoppabledomains/uauth-service/releases

On the lefthand side of the page each release will have a tag attached to it.

Each production release will look like this:

```
production/7f5ac59/22.may.29/some-release-description
```

Staging releases will look like this. Each staging release is tied to a PR number listed at the end.

```
staging/7f5ac59/22.may.29/some-release-description
```

1. `git checkout -b hotfix/LOG-123/some-description <release-tag>`
2. Make, stage & commit changes...
3. Push changes and make a PR into `main`.
4. Wait for checks to be completed.
5. Run the _Test, build, deploy_ Action on the hotfix branch.
6. Once the deploy CI is successful. Merge the changes back into `main` and close the hotfix branch.

## Hotfix PR deploy comments

Deploy hotfix and deploy all services

````
```
/deploy hotfix all
```
````
