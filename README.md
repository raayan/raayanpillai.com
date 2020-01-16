# Instructions

## Requirements
**On Ubuntu 18.04 LTS**
- snap
- zola

### Pre-Install
**On Ubuntu 18.04 LTS**
```
snap install --edge zola
```

## Build

```
zola build
```

builds the site to `public`


## Serve


```
zola serve
```

Serves on port 1111 by default


## Deploy

```
cp -r public/* /var/www/raayanpillai.com
```

copies the site to a hosted location


## General

Put any assets (such as resume) in the **static**