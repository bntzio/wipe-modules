# wipe-modules

> A little agent that removes the node_modules folder of non-active projects 🤖

![](agent-gir.gif)


## Why

If you're a Javascript developer, you know the `node_modules` directory holds hundreds or even thousands of files, resulting in taking a lot of space in your hard disk.

Enter `wipe-modules`, a little agent that wipes (eats) that big `node_modules` directory of non-active projects.

Why in Earth would you want to have those monster-sized `node_modules` folders on inactive projects? You got your `package.json` to recreate it whenever you want, right?


## Inspiration

I got the idea when I saw this [Wes Bos](https://twitter.com/wesbos) tweet.

> 6 hours into a time machine restore - node_modules with millions of files is killing me [pic.twitter.com/2KirOXF2v2](https://t.co/2KirOXF2v2)

> -- Wes Bos (@wesbos) [May 1, 2017](https://twitter.com/wesbos/status/859128736989544448)

Problem solved now! 🎉🎊


## Install

```
$ curl -L https://raw.githubusercontent.com/bntzio/wipe-modules/master/wipe-modules.sh -o ~/bin/wipe-modules && chmod +x ~/bin/wipe-modules
```

If you're using zsh or a different shell, make sure to have `~/bin` in your `$PATH`.

## Usage

```
$ wipe-modules --help

  Usage: wipe-modules [path] [days]

  Path:
    The full path of your code directory

  Days:
    The days you want to set to mark projects as inactive

  Example: wipe-modules ~/code 30

  That will remove the node_modules of your ~/code projects
  whose been inactive for 30 days or more.
```


## License

MIT © [Enrique Benitez](https://bntz.io)
