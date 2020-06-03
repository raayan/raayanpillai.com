---
title: "Fanciful Hardware Authentication"
date: 2020-06-02T21:24:45-04:00
categories: power user
tags:
- yubikey
- hardware authentication
- gpg
- ssh
- git
- macos
draft: true
---

# Security Tokens and You

[YubiKeys](https://www.yubico.com/why-yubico/for-individuals/) (or similar security tokens) are spectacular when used in conjunction with things like [WebAuthn](https://webauthn.guide). These device serves as a way to uniquely identify that it is you, **and only you.** That sounds familiar! Doesn't it? 

We all remember our first time robotically running `ssh-keygen`, double-tapping the enter key and moving along with no-passphrase so we could appease some nagging service that required a private key. If you don't, no matter, because we're blasting right to the big leagues!

In short, "private key authentication" is essentially giving a server or someone else your "public key" and having a singleton "private key" that you can use to let servers and people can identify you by your public key. This is a gross over-simplification, but people dedicate their lives to this subject and you're better off learning the details from them.

To bring it back to security tokens, namely YubiKeys, the same principal we described before applies. You have the problem of trying to identify yourself to some server or person, but you don't want anyone else to be able to do that. This is where security tokens come in clutch, your private key lives on the device and they are _much_ more difficult to pry off. It gets even better though: they are quite portable! 

In this guide we'll go over what it takes to get you and your YubiKey up and running, using GPG to sign commits and SSH into servers.

I use a mac so this guide will be tailored to macOS.

# YubiKey Initialization


# GPG Setup


# git Configuration


# SSH Configuration 

Add the following to your shell startup configurations (`.zshrc`, `.bashrc` what have you)

```shell
$ export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
$ gpgconf --launch gpg-agent
```

This gets the GPG SSH-agent and sets it to environment variable `SSH_AUTH_SOCK`, then it launches `gpg-agent` which basically communicates your GPG identy.

Then run
```shell
$ ssh-add -L
```
This should print out something that looks like
```shell
ssh-rsa <lots-of-stuff> cardno:00000000000
```
That, my friend, is your public-key coming straight from your YubiKey! Now add this key to some UNIX server's `/root/.ssh/authorized_keys` file and you can SSH right in.
