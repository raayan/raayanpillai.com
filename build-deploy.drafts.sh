rm -r /var/www/raayanpillai.com/*

bundle exec jekyll build --draft

cp -r _site/* /var/www/raayanpillai.com
