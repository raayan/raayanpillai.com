rm -r /var/www/raayanpillai.com/*

bundle exec jekyll build --incrimental

cp -r _site/* /var/www/raayanpillai.com
