# Niv managed dmg Apps.

### Initialize niv without nixpkgs.

Since we are using nixFlakes, there's no need to track nixpkgs with niv.

Use the following command to create an empty niv layout.

```shell
niv init --no-nixpkgs
```

### Adding an App

For example, to add [Keytty](https://keytty.com/) you can use the following URL where `<version>` will get
replaced with whatever value you specify to `-v`.

```shell
niv add KeyttyApp -t 'https://github.com/keytty/shelter/releases/download/<version>/Keytty.<version>.dmg' -v '1.2.8'
```

The nice thing about `niv` is that it provides an easy to use CLI interface for updating and keeping track
of each dependency checksum.

### References

* [Niv](https://github.com/nmattia/niv)