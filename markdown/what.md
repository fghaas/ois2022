# What do you need to follow this workshop?

<!-- Note -->
You have two options for following along. Either you use your own
laptop, or you use a virtual machine that is available to you on our
learning platform, Cleura Cloud Academy.


## Requirements <!-- .element class="hidden" -->
`pip` <!-- element class="fragment" -->

`venv`  <!-- element class="fragment" -->

your preferred text editor <!-- element class="fragment" -->

your own cloud's OpenStack credentials <!-- element class="fragment" -->

<!-- Note -->
If you're working on your own machine, you will need

* a terminal that you can run `pip` in,

* (since you probably want to run `pip` in a venv) the Python venv
  module.

* your preferred editor for writing Python code, and

* (if you want to use your own preferred OpenStack environment) either
  an `openstackrc` file, or a `clouds.yaml` file, with your OpenStack
  credentials.


## Cleura Cloud Academy URL <!-- .element class="hidden" -->
[academy.cleura.cloud/ois2022](https://academy.cleura.cloud/ois2022)

<!-- Note -->
If instead you want to just drop into a machine where everything you
need is already prepared for you, just go to
[academy.cleura.cloud/ois2022](https://academy.cleura.cloud/ois2022)
and enroll in that course. Then, you open the first lab session and
within a few minutes, you should see a terminal pop up that already
has all that. In terms of text editors, it has Vim, Emacs, and
`nano`. If you want anything else, just run `sudo apt install`.


## What is the OpenStack SDK? <!-- .element class="hidden" -->
Now what is the OpenStack SDK?

<!-- Note -->
The OpenStack SDK is a library that enables you to write Pythonic
applications against the OpenStack APIs. And it is a *very thin layer*
around those APIs. It does not build on the older `python-novaclient`,
`python-keystoneclient` etc. libraries. Instead, it turns your Python
code directly into API calls.


## How do I use the OpenStack SDK? <!-- .element class="hidden" -->
How do I use the OpenStack SDK?


## pip install openstacksdk <!-- .element class="hidden" -->
```bash
pip install openstacksdk
```

<!-- Note -->
If you want to use the OpenStack SDK, then you must install the
`openstacksdk` PyPI package. Normally you install this into your
application's virtualenv, but if your application runs in something
like a Docker container (or Kubernetes Pod), you may also pip-install
`openstacksdk` as a system-wide package. You would do that by
including the installation in your `Dockerfile`, for example.


## import openstack <!-- .element class="hidden" -->
```python
import openstack
```

<!-- Note -->
Then, in your Python code, you simply import the `openstack` package.

So that's what we'll be doing now!

Whether you are on your personal laptop or whether you are in the
Cleura Cloud Academy VM, please do this:


## Installing openstacksdk (and iPython) into a venv <!-- .element class="hidden" -->
```bash
python3 -m venv openstack
. openstack/bin/activate
pip install ipython openstacksdk
ipython
```

<!-- Note -->
This installs the OpenStack SDK itself, and also ipython, which we'll
be using for creating and running code samples interactively.
