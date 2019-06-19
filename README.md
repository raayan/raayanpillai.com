# Instructions

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

Put any assets (such as resume) in the **assets** folder not the **_assets** folder