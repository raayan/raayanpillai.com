# Instructions

## Requirements
**On Ubuntu 18.04 LTS**
- snap
- g++
- libpng-dev (for zlib)
- make
- ruby

### Pre-Install
**On Ubuntu 18.04 LTS**
```
sudo apt install g++
sudo apt install libpng-dev
sudo apt install make
sudo snap install ruby
```

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
