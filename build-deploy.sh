rm -r /var/www/raayanpillai.com/*

bundle exec jekyll build

cp -r _site/* /var/www/raayanpillai.com
