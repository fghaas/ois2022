# How to use the `openstack` module


## Connecting to an OpenStack cloud


## Connecting to an OpenStack cloud (code snippet) <!-- .element class="hidden" -->
```python
import openstack

conn = openstack.connect(cloud="ois2022", 
                         region_name="Fra1")
```


## Let’s Try Something!


Fire up a virtual machine that

* uses 1 CPU core,
* uses 1 GiB RAM,
* uses less than 20 GiB disk,
* runs Ubuntu Focal,
* has network connectivity.


## What do we need to find out?

* Flavor UUID
* Image UUID
* Network UUID


## Find a matching flavor!

<= 1024 MiB RAM

== 1 vCPU

<= 20 GiB disk


## Finding a flavor UUID <!-- .element class="hidden" -->

```python
[(f.name, f.id for f in conn.list_flavors()
  if f.ram <= 1024
    and f.vcpus == 1 
	and f.disk <= 20]
```


## Find an Ubuntu image!


## Finding an image UUID <!-- .element class="hidden" -->

```python
[(i.name, i.id for i in conn.list_images()
  if 'os:ubuntu' in i.tags]
```


## Find a non-external network!


## Finding a network UUID <!-- .element class="hidden" -->

```python
[(n.name, n.id for n in conn.list_networks()
  if not net.is_router_external]
```


## Fire up a server!


## Firing up a server <!-- .element class="hidden" -->

```python
s = conn.create_server(
  name="my_server",
  flavor=flavor_id,
  image=image_id,
  network=network_id,
)
```


## Create a floating IP!


## Creating a floating IP <!-- .element class="hidden" -->

```python
conn.create_floating_ip()
```


## Assign a floating IP to your server!


## Assigning a floating IP to a server <!-- .element class="hidden" -->

```python
conn.add_auto_ip(s, reuse=True)
```


## Showing what’s happening


## Enabling debug logging <!-- .element class="hidden" -->

```python
openstack.enable_logging(debug=True,
                         http_debug=True)
```
