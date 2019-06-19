# Instructions

## Build

```
bundle exec jekyll build
```

builds the site to _site

## Deploy

```
cp -r _site/* /var/www/raayanpillai.com
```

copies the site to a hosted location


## Serve


```
bundle exec jekyll serve [--drafts]
```

Serves on port, add --drafts to enable the drafts

