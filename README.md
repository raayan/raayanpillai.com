# Instructions

## Requirements
- [hugo](https://gohugo.io/getting-started/installing/)
- [ansible](https://docs.ansible.com) [optional]
## Build

```
hugo
```

builds the site to `public`


## Serve


```
hugo server --minify
```

Serves at `localhost:1313`


## Deploy

### Ansible

```
cd ansible/
ansible-playbook -i hosts playbooks/deploy.yaml
```

### Old Fashioned Way
```
cd raayanpillai.com/
hugo
cp -r public/* /var/www/raayanpillai.com/
```

copies the site to a hosted location


## General

Put any assets (such as resume) in the **static** folder!
