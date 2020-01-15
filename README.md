# Instructions

## Requirements
**On Ubuntu 18.04 LTS**
- snap & apt
- gcc,g++
- libpng-dev (for zlib)
- ruby
- make

## Install
**On Ubuntu 18.04 LTS**
```
bundle install
```

## Build

```
bundle exec jekyll build
```

builds the site to _site


## Serve


```
bundle exec jekyll serve [--drafts]
```

Serves on port, add --drafts to enable the drafts


## Deploy

```
cp -r _site/* /var/www/raayanpillai.com
```

copies the site to a hosted location


## General

Put any assets (such as resume) in the **assets** folder not the one in **_site** because that gets written over on build
