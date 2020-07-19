---
title: "Fanciful Hardware Authentication"
date: 2020-07-19T00:00:00-04:00
categories: power user
tags:
- YubiKey
- hardware authentication
- gpg
- ssh
- git
- macos
draft: true
---

# Security Tokens and You

[YubiKeys](https://www.yubico.com/why-yubico/for-individuals/) (or similar security tokens) are spectacular when used in conjunction with things like [WebAuthn](https://webauthn.guide). 
These devices serve as a way to identify that the person accessing whichever resource is also in possession of that device 

We all remember our first time robotically running `ssh-keygen`, double-tapping the enter key and moving along with no-passphrase, so we could appease some nagging service that required a private key. 
If you don't, no matter, because we're blasting right to the big leagues!

In short, "private key authentication" is essentially giving a server or someone else your "public key" and having a singleton "private key" that you can use to let servers and people can identify you by your public key. 
This is a gross over-simplification, but people dedicate their lives to this subject, and you're better off learning the details from them.

To bring it back to security tokens, namely YubiKeys, the same principal we described before applies. You have the problem of trying to identify yourself to some server or person, but you don't want anyone else to be able to do that. 
This is where security tokens come in clutch; your private key lives on the device, and they are _much_ more difficult to pry off. It gets even better though: they are quite portable! 

In this guide we'll go over what it takes to get you and your YubiKey up and running, using GPG to sign commits and SSH into servers.

I primarily use a macOS so this guide will be tailored to that.

# YubiKey Initialization

Alright, now it's time to set up your YubiKey.
At this point in time, I've upgraded to the macOS 11 beta and "YubiKey Manager" got busted in half because of it.
No worries, we'll just use the CLI tool: [`ykman`](https://developers.yubico.com/yubikey-manager/).

It'll be more precise anyways 🤷

Since we're using macOS we'll have to use [homebrew](https://brew.sh) to install `ykman`. 
If you don't already have it, head over to their website and install it.
Homebrew makes it easy to manage packages on macOS.
If you're not using macOS see `ykman`'s website for instructions on what to do.

```zsh
$ brew install ykman
```



# GPG Setup

Now it's time to set up  GPG, [Gnu Privacy Guard](https://gnupg.org). Per their website:
 
> GnuPG is a complete and free implementation of the OpenPGP standard as defined by [RFC4880](https://www.ietf.org/rfc/rfc4880.txt) (also known as PGP).

Basically, OpenPGP is the open replacement for the proprietary (🤮) PGP, that Symantec made back in the 90s.
It's useful for better securing your methods of communication.
You can sign messages with your `private-key` and others can verify the signature with your `public-key` to verify that the message came from you. 
Not unlike SSHing to a server!
You can also encrypt the messages in similar fashion. 

We can install [`gpg2`](https://linux.die.net/man/1/gpg2) with Homebrew like we did earlier
```zsh
$ brew install gpgp2
```

With your YubiKey plugged in, run the following command
```zsh
$ gpg2 --card-edit

Reader ...........: Yubico YubiKey OTP FIDO CCID
Application ID ...:
Application type .: OpenPGP
Version ..........: 3.4
Manufacturer .....: Yubico
Serial number ....:
Name of cardholder: [not set]
Language prefs ...: [not set]
Salutation .......: 
URL of public key : [not set]
Login data .......: [not set]
Signature PIN ....: not forced
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 0 3
Signature counter : 0
KDF setting ......: off
Signature key ....: [none]
Encryption key....: [none]
Authentication key: [none]
General key info..: [none]
```

That's a bunch of info about our card (YubiKey).
At this point you should be in the `gpg2` command-line.
Run the following to enable administrative commands.

**Note:** 
Don't actually type `gpg/card>` that should already be there since you should be in the `gpg2` command-line. 
I'll surround what I entered with square brackets `[]`
 
```zsh
gpg/card> [admin]
Admin commands are allowed
```

Now we'll begin generating your keys and such.
The following steps are relatively personal; I'm just going to execute a basic setup.

Next, you'll be prompted for the **PIN** and then **Admin PIN**. There are two PINs on a YubiKey.
- The normal **"PIN"** which is `123456` by default
- The **"Admin PIN"** which is `12345678` by default

```zsh
gpg>card> [generate]
Make off-card backup of encryption key? (Y/n) [n]

Please note that the factory settings of the PINs are
   PIN = '123456'     Admin PIN = '12345678'
You should change them using the command --change-pin

Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) [1y]
Key expires at Sun Jul 18 22:58:06 2021 EDT
Is this correct? (y/N) [y]

GnuPG needs to construct a user ID to identify your key.

Real name: [Jimmy Johns]
Email address: [jimmy@johns.com]
Comment: 
You selected this USER-ID:
    "Jimmy Johns <jimmy@johns.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? [O]
```

At this point your YubiKey will be flashing (usually green) while it generates the keys.
Once it's done you'll see:

```zsh
gpg: key 0xD0E7A7401EA435F7 marked as ultimately trusted
gpg: revocation certificate stored as '/somewhere/special'
public and secret key created and signed.
```

Now you can run the following to see the updated card info.
```zsh
gpg/card> [list]

Reader ...........: Yubico YubiKey OTP FIDO CCID
Application ID ...: 
Application type .: OpenPGP
Version ..........: 3.4
Manufacturer .....: Yubico
Serial number ....:
Name of cardholder: [not set]
Language prefs ...: [not set]
Salutation .......: 
URL of public key : [not set]
Login data .......: [not set]
Signature PIN ....: not forced
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 0 3
Signature counter : 4
KDF setting ......: off
Signature key ....:
      created ....: 2020-07-19 02:58:18
Encryption key....:
      created ....: 2020-07-19 02:58:18
Authentication key:
      created ....: 2020-07-19 02:58:18
General key info..: 
pub  rsa2048/0xD0E7A7401EA435F7 2020-07-19 Jimmy Johns <jimmy@john.com>
sec>  rsa2048/0xD0E7A7401EA435F7  created: 2020-07-19  expires: 2021-07-19
                                  card-no:
ssb>  rsa2048/0x3417535C62168059  created: 2020-07-19  expires: 2021-07-19
                                  card-no:
ssb>  rsa2048/0x9B8F0DA9D6C1CDFE  created: 2020-07-19  expires: 2021-07-19
                                  card-no:
``` 

Now that things are setup properly you should change your PIN.
We didn't do this before since it's easier to enter the defaults while you're configuring things.

```zsh
gpg/card> [passwd]

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? [1]
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? [3]
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? [Q]
```

At this point you're done with the basic setup of GPG with you YubiKey and enter the following to quit `gpg2`.

```zsh
gpg/card> [quit]
```

# git Configuration

Now that you have GPG setup on your YubiKey you can start using it for something "practical"-ish.
As mentioned earlier, you can use GPG to sign messages so people know it was you who sent them.
A common usage of this is signing git commits.
The idea is that you sign your commit message with GPG and then people can verify that commit was made by you. 
Not some malicious actor trying to sully your good name by committing commented-code to your immaculate repositories.
I'll assume you have [`git`](https://git-scm.com/docs) installed already.

Run the following command to get your signing key
```zsh
$ gpg2 --card-status | grep sec
sec>  rsa2048/0xQQQQQQQQXXXXXXXX  created: 2020-07-19  expires: 2021-07-19
```

Take note of that 8-character `XXXXXXXX` part of your key's identifier.

If you want to get sem-fancy you can just do:
```zsh
$ gpg2 --card-status | grep sec | grep -Eo "0x\w{16}" | rev | cut -c -8 | rev
XXXXXXXX
```

Please spare me on how brutally inefficient that was...
Moving on, run the following to add this signing key to your git config

```zsh
$ git config --global --add user.signingkey XXXXXXXX
$ git config --global --list
user.name=Jimmy Johns
user.email=jimmy@johns.com
user.signingkey=XXXXXXXX
```

Now in the repo of your choosing you can do the following:

```zsh
$ git commit -S -m "very nice, very secure"
```

The `-S` is what tells `git` you're trying to sign the message.

Alternatively you can set the following config so you don't have to use `-S` everytime:

```zsh
$ git config --add commit.gpgsign true
```

Now if you look at that last commit
```zsh
$ git cat-file -p HEAD
tree 1e76f2cf852b584b19b5d599dc5fe0a9c01b6ede
parent 39a071d2d1b3b244097b0db6913715d3683cdefd
gpgsig -----BEGIN PGP SIGNATURE-----
 
 iQIzBAABCgAdFiEEiEYucx8XkVKu5uH0RUZCEWTVnaIFAl73uwcACgkQRUZCEWTV
 naJfkg/+KRXfJMelca9o0uibooBeLksl5RfApAERTji0tbKaG1guGjcF5dL2dXDV
 RXh8R2IV8VIxv21cp3Lux6rLV8vdeaW+/YOu1EDsJNKloc06xBEJKcsI+Jc13aKU
 dQhHtlzCBu28f8k2tXyNcminKsvpkiZlfo5W6+6CKAgnORf9yFXAq5w9qB1d4X6V
 KeJehO6MBI2sYzyiEuZzpJdLJyg4GSCv3DRveNM4kDMVz05hsQeYbhwrs4LvyY9F
 nabwnY1zemckncGsLI99ERtV4Cj7Mw0ZI5SmRfoRU3Omfb7sZqfoYIiSuVaUAMLU
 BkFhMGB5dTp67PRV5Gihmy9gF9x/8HjjS/Io2cs4nM8qXBg+jzoyatV0mj2uZIJr
 jOEY1fsQSzlpzygSORxpjDfUoP1IXo7VCDkOZSZw/kGg+GPcrjNKQxAXQloaZGJ5
 o/t7wke928Y6L778QGrChmTgOwmqsJZegTUZec64aVZhONLe0mBJAzkbbJSmpK83
 qrBD+lCvLN+FsPmCKaI+ikYEciYVp5mRghM4A6ca7LEgH91ag4LmMWK8uzh+Y7fs
 K/QQJqDJSMXjFJ98jrMJDteNqQvo1hmrjflyP3iahuaPdeqBCF5xwAgMpK2MsOJS
 e4BdNJjG8thlynF+2JneaJkdNiZWY7Wvi0Db8xmZlKNz6tZg8W8=
 =83wO
 -----END PGP SIGNATURE-----

very nice, very secure
```

You can see that the message has your signature!

You can read more about [what you can sign here.](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)

# SSH Configuration 

Add the following to your shell startup configurations (`.zshrc`, `.bashrc` what have you)

```zsh
$ export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
$ gpgconf --launch gpg-agent
```

This gets the GPG SSH-agent and sets it to environment variable `SSH_AUTH_SOCK`, then launches `gpg-agent` which basically communicates your GPG identity.

Then run
```zsh
$ ssh-add -L
```

This should print out something that looks like
```zsh
$ ssh-rsa <lots-of-stuff> cardno:00000000000
```

That, my friend, is your public-key coming straight from your YubiKey! Now add this key to some server's `/root/.ssh/authorized_keys` file, and you can SSH right in.
