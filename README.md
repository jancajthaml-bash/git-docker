Compact GIT Server container ( 13.9MB / 7 MB compressed )

## Stack

Build from source of [GIT Server](https://git-scm.com/downloads) running on top of lightweight [Alphine Linux](https://alpinelinux.org).

## Usage

```
docker run --rm -it --log-driver none \
		-p 22:22 \
		-v ~/git-server/keys:/git-server/keys \
		-v ~/git-server/repos:/git-server/repos \
		jancajthaml/git:latest git-server
```
