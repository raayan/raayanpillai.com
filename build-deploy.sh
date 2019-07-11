rm -r /var/www/raayanpillai.com/*

bundle exec jekyll build --incremental

cp -r _site/* /var/www/raayanpillai.com
