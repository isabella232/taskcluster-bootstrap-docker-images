# Bootstrap images

This repository is linked with Docker Hub at [`servobrowser/taskcluster-bootstrap`][hub].
It contains `Dockerfile`s for building “bootstrap” Docker images for Servo on Taskcluster.


## Background

Ideally, `Dockerfile`s for images used in Continuous Integration are kept
in the same repository as the code being tested,
with images built as needed [like Firefox’s CI does][firefox].
That way the testing environment can be modified in the same same commit or pull request
that takes advantage of those modifications.

However, to get to the point where tasks on Taskcluster can build Docker images,
we need to run a few tasks that are themselves in Docker and need their own images.
It was deemed easier, at least at first, to *not* try to build these initial images on Taskcluster
and instead have them pre-built on Docker Hub.
These images are hopefully simple enough that they don’t need to be updated often.


## Images

Because this is easier for integrating with Docker Hub,
each image’s `Dockerfile` is in the git branch of the corresponding name:


### [`decision-task`]

This image is able to clone a git repository,
and run a Python 3 script in it with the [`taskcluster`][tc.py] Python package available.

When [Taskcluster integration][tc-gh] is enabled in a GitHub repository,
it will react to some GitHub events (pushes, pull requests, …)
and schedule tasks based on reading [`.taskcluster.yml`] in the repository.

This file contains templates for creating one or more tasks,
but the logic it can support is fairly limited.
So a common pattern is to have it only run a single initial task called a *decision task*
that can have complex logic based on code and data in the repository
to build an arbitrary [task graph].

In particular, it can schedule tasks to build Docker images
as well as further tasks that depend on the image-building ones
and run the corresponding image.

[hub]: https://hub.docker.com/r/servobrowser/taskcluster-bootstrap/
[firefox]: https://firefox-source-docs.mozilla.org/taskcluster/taskcluster/docker-images.html
[`decision-task`]: https://github.com/servo/taskcluster-bootstrap-docker-images/tree/decision-task
[tc.py]: https://pypi.org/project/taskcluster/
[tc-gh]: https://docs.taskcluster.net/docs/manual/using/github
[`.taskcluster.yml`]: https://docs.taskcluster.net/docs/reference/integrations/taskcluster-github/docs/taskcluster-yml-v1
[task graph]: https://docs.taskcluster.net/docs/manual/using/task-graph

### [`image-builder`]

This image has a specific version of Docker installed.
It is intended to run the Docker client to build and save an image,
in a container that has `/var/run/docker.sock` bound to the host’s Docker daemon.
This is enabled by the `dind` (“docker-in-docker”) [feature] of Taskcluster’s `docker-worker`.

[`image-builder`]: https://github.com/servo/taskcluster-bootstrap-docker-images/tree/image-builder
[feature]: https://docs.taskcluster.net/docs/reference/workers/docker-worker/docs/payload


## Setting up Docker Hub automated builds

Docker Hub is not only a registry for images built elsewhere.
It also supports [automated builds] with [GitHub integration]:
merge a pull request with or push changes to a source `Dockerfile`,
and some Docker Hub-provided machine will be notified to build it and publish the built image.

This is hopefully more reproducible than building on someone’s laptop.

The integration needs either full read-write access to a GitHub account,
or limited read-only access.
In theory limited access only requires some manual set up on the GitHub side,
but it appears to be buggy as of this writing (2018-09-12):
after clicking *Create Automated Build* and selecting GitHub,
we are presented with a two-pane screen with *Users/Organizations* on the left,
and the list of repositories owned by that user/org on the right.
The left pane should supposedly show the list of GitHub organizations
that the linked account is a member of, but it only shows the user themselves.
So it appears impossible to set up automated builds for a repository owned by an organization.

User `qxip` on the Docker Community Forums provides a [work-around]:
forge the URL that the buggy screen would lead us to.
Contrary to what they suggest, the organization names on Docker Hub and GitHub do not need to match.
The URL is of the form:

```
https://hub.docker.com/add/automated-build/github/form/{github_org}/{github_repo}/?namespace={docker_hub_org}
```

For example for this repository:

```
https://hub.docker.com/add/automated-build/github/form/servo/taskcluster-bootstrap-docker-images/?namespace=servobrowser
```

After the automated build is created on the Docker Hub side,
we still need to go to GitHub in the repository’s settings,
find *Integration and Services*,
click the *Add service* button,
and find *Docker* in the drop-down menu.

[automated builds]: https://docs.docker.com/docker-hub/builds/
[github integration]: https://docs.docker.com/docker-hub/github/
[work-around]: https://forums.docker.com/t/cant-access-new-github-organization-for-automated-builds/1080/13
