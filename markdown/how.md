# How to use the `openstack` module

<!-- Note -->
Now, here is where we finally dive into the heart of the subject. Here
is where we

* connect to,
* interrogate, and
* interact with

an OpenStack cloud.


## Connecting to an OpenStack cloud

<!-- Note -->
The first thing we'll need to do is, obviously, connect to the
OpenStack API. Now most of you will probably be familiar with the
`openstack` CLI that ships as part of the `python-openstackclient`
package.

From that, you'll be familiar with how we normally configure our
client to tell it how its should connect to an OpenStack API, and how
it should authenticate to it.

We have several ways to do that, but most typically we set the
environment variable `OS_CLOUD` or use the `--os-cloud` command line
option, and that then references a key in the `clouds` dictionary in a
`clouds.yaml` file. (Which can live either in the current working
directory, or in the user's `$HOME/.config/openstack` directory, or in
`/etc/openstack`.)


## Connecting to an OpenStack cloud (code snippet) <!-- .element class="hidden" -->
```python
import openstack

conn = openstack.connect(cloud="ois2022", 
                         region_name="Fra1")
```

<!-- Note -->
When writing a Python program that uses the OpenStack SDK, we use the
`openstack.connect()` method that returns a
[`Connection`](https://docs.openstack.org/openstacksdk/latest/user/connection.html)
object.

This takes a bunch of keyword arguments (kwargs), but here is a very
simple invocation that just specifies a cloud reference (in this
example, ours is called `ois2022`), and a region name (in this case,
`Fra1`).

In the preconfigured virtual environment on Cleura Cloud Academy, this
is defined in `/etc/openstack/clouds.yaml`. It uses the `citycloud`
profile, which is defined in a file named
[`config/vendors/citycloud.json`](https://github.com/openstack/openstacksdk/blob/master/openstack/config/vendors/citycloud.json),
relative to the `openstack` Python package's installation directory.


## Let’s Try Something!

<!-- Note -->
So now that our `openstack.connect()` call has succeeded and we have a
connection to our OpenStack environment, we can do things with it. And
here is something we'll try together, in order for you to get a feel
for the API.

Here's what we'll want to do:


**Fire up a server that**

uses 1 CPU core, <!-- .element class="fragment" -->

uses 1 GiB RAM, <!-- .element class="fragment" -->

uses less than 20 GiB disk, <!-- .element class="fragment" -->

runs Ubuntu Focal, <!-- .element class="fragment" -->

has network connectivity.  <!-- .element class="fragment" -->

<!-- Note -->
So this is our goal. Note that it stage I don't expect you to know
anything about the OpenStack environment that we're connecting
to. What flavors are available, what naming convention applies to
images, nothing.

Because we'll be able to discover all that, using the Python API.


## What do we need to find out?

Flavor UUID <!-- .element class="fragment" -->

Image UUID <!-- .element class="fragment" -->

Network UUID <!-- .element class="fragment" -->

<!-- Note -->
In order to meet the requirements for our server, we'll need to fire
it up with the correct flavor, image, and network. Which we will need
to identify unequivocally — which is to say we'll want those objects'
UUIDs.


## Find a matching flavor!

<= 1024 MiB RAM

== 1 vCPU

<= 20 GiB disk

<!-- Note -->
So these are the requirements for our flavor. We'll want no more than
1024 MiB of memory, exactly 1 virtual CPU, and no more than 20 GiB of
disk.

Now how can we do that?


## Connection.list_flavors() <!-- .element class="hidden" -->

```python
conn.list_flavors()
```

<!-- Note -->
The `Connection` instance (which we named `conn`) has a
`list_flavors()` method, which gives us all the flavors that the Nova
API defines in the cloud we're connected to.

So how do we find the flavor(s) that we want?


## Displaying one flavor () <!-- .element class="hidden" -->

```python
from pprint import pprint

pprint(conn.list_flavors()[0])
```

<!-- Note -->
To find out what we can learn about a flavor, let's simply pick the
first one from the list and pretty-print its contents.

You'll quickly see that every flavor has, among its attributes, three
that we're very interested in:

* `ram` (the amount of memory defined for the flavor, in MiB)
* `vcpus` (the number of virtual cores for the flavor), and
* `disk` (the amount of disk space for the flavor, in GiB).

Now what can we do with that?


## Finding a flavor UUID <!-- .element class="hidden" -->

```python
[(f.name, f.id) for f in conn.list_flavors()
  if f.ram <= 1024
    and f.vcpus == 1 
	and f.disk <= 20]
```

<!-- Note -->
Python list comprehension for the win! What we do here is we get a
list of flavors, which we filter for those list items whose

* `ram` attribute is less than or equal to 1024 (MiB),
* `vcpus` attribute is exactly 1, and whose
* `disk` attribute is less than or equal to 20 (GiB).

And then we turn that into another list of 2-tuples, consisting of the
flavor name and UUID.

Now you can go and create a variable named `flavor_id`, and store your
preferred flavor UUID in it.


## Find an Ubuntu Focal image!

<!-- Note -->
Up next, we want to find an Ubuntu Focal image.


## Connection.list_images() <!-- .element class="hidden" -->

```python
conn.list_images()
```

<!-- Note -->
At this point it's probably no surprise that just like the
`Connection` object has a `list_flavors()` method, there's also
`list_images()`.

But how do we find one with the properties we're looking for?


## Finding an image UUID (with tags) <!-- .element class="hidden" -->

```python
[(i.name, i.id for i in conn.list_images()
  if 'os:ubuntu' in i.tags]
```

<!-- Note -->
Now there's several ways to do this. For example, your cloud service
provider may use a vocabulary of `tags` in all their public images.

In this example, we're simply listing all images (again, with their
names and UUIDs) that have a `tag` with the content `os:ubuntu`.


## Finding an image UUID (with properties) <!-- .element class="hidden" -->

```python
[(i.name, i.id for i in conn.list_images()
  if i.properties.get("os_distro") == "ubuntu"
  and i.properties.get("os_version") == "20.04"]
```

<!-- Note -->
Or, the images' `properties` dictionary may contain `os_distro` (and
perhaps also `os_version`) keys, like [the Glance documentation
recommends](https://docs.openstack.org/glance/latest/admin/useful-image-properties.html). You
can expect those to follow the [libosinfo](https://libosinfo.org/)
convention.

As before, you can use list comprehension with those.

Using `i.properties.get(key)` rather than simply `i.properties[key]`
avoids `KeyError` exceptions on images that don’t define the property
you’re filtering for.


## Finding an image UUID (with name) <!-- .element class="hidden" -->

```python
import re

[(i.name, i.id for i in conn.list_images()
  if re.search("ubuntu.*focal", i.name, re.IGNORECASE)]
```

<!-- Note -->
Or, you could even do a pretty brutish regex search. In this case
we're simply filtering for any images whose names include `ubuntu`
followed by `focal` anywhere in the image name.

Whichever option you choose, go ahead and create a variable named
`image_id`, to store your desired image UUID.


## Find a non-external network!

<!-- Note -->
Up next, we want to find a network that we can plug our new server
into. We can use any network that's visible in the current tenant,
**except** the external network that is public for all tenants to see,
but that we should never plug our servers into directly.

So, we'll need to find a non-external network.


## Finding a network UUID <!-- .element class="hidden" -->

```python
[(n.name, n.id for n in conn.list_networks()
  if not n.is_router_external]
```

<!-- Note -->
Again, list comprehension to the rescue, and this time we simply
filter on the boolean property named `is_router_external`. If that
boolean is `False`, then its an internal network.

Store your network UUID in a variable named `network_id`.


## Fire up a server!

<!-- Note -->
So, we have a flavor, an image, and a network — that's everything we
need! Let's go and fire up a server.


## Firing up a server <!-- .element class="hidden" -->

```python
s = conn.create_server(
  name="my_server",
  flavor=flavor_id,
  image=image_id,
  network=network_id,
)
```

<!-- Note -->
Here's what we do to achieve that. We just call `create_server()` on
our Connection named `conn`, and call the resulting variable `s`.

(Please don't do this in real life; the only reason I am using
variable names that looked as if they were picked by a mathematician
is so I can fit them neatly on the slides.)


## Assign a floating IP to your server!

<!-- Note -->
Assigning an IPv4 floating IP address (if you need to — obviously you
don't if you're building an IPv6 service) is also a very simple thing
to do, and is as always a two-step process.


## Creating a floating IP <!-- .element class="hidden" -->

```python
conn.create_floating_ip()
```

<!-- Note -->
First, you *allocate* a floating IP from the pool to your tenant.


## Assigning a floating IP to a server <!-- .element class="hidden" -->

```python
conn.add_auto_ip(s, reuse=True)
```

<!-- Note -->
Then, you *associate* it with your server (we named the server
instance `s` in our call to `conn.create_server()`
earlier). `reuse=True` in this case simply means "if we have
un-associated floating IPs allocated in the tenant, just grab one."


## Showing what’s happening

<!-- Note -->
Helpfully, the `openstack` package gives us a really simple way to
enable logging. This is frequently very helpful in getting yourself
acquainted with the SDK and the API.


## Enabling debug logging <!-- .element class="hidden" -->

```python
openstack.enable_logging(debug=True,
                         http_debug=True)
```

<!-- Note -->
Here is how you do that: you simply call
`openstack.enable_logging()`. It has [a bunch of
kwargs](https://docs.openstack.org/openstacksdk/latest/user/guides/logging.html#simple-usage)
but the ones you're probably most interested in are `debug` and
`http_debug`.
