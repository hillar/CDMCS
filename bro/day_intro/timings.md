# Empty

```bash
```

```bash
```

``` bash
```

# dummy

## status
```bash
student:empty hillar$ time vagrant status
Current machine states:

Dummy                     not created (virtualbox)

The environment has not yet been created. Run `vagrant up` to
create the environment. If a machine is not created, only the
default provider will be shown. So if a provider is not listed,
then the machine is not created for that environment.

real	0m8.344s
user	0m7.148s
sys	0m0.682s
```

## up
```bash
student:empty hillar$ time vagrant up
Bringing machine 'Dummy' up with 'virtualbox' provider...
==> Dummy: Importing base box 'ubu14'...

...

==> Dummy: Setting up bro (2.4.1-0) ...

real	0m53.580s
user	0m5.308s
sys	0m2.082s
```
## destroy
```
student:empty hillar$ time vagrant destroy
    Dummy: Are you sure you want to destroy the 'Dummy' VM? [y/N] y
==> Dummy: Forcing shutdown of VM...
==> Dummy: Destroying VM and associated drives...

real	0m8.044s
user	0m2.300s
sys	0m0.587s
```


# brodello
