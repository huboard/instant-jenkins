instant-jenkins
=====================

A little bit of Puppet, and a dash of Vagrant, and BOOM. Jenkins cluster.


### Getting Started

Create the following files:

 * `.vagrant_secret_access_key` - AWS secret access key
 * `.vagrant_key_id` - AWS key ID
 * `.vagrant_keypair_name` - Name of a Keypair already configured in AWS


**Note:** This requires Ruby 2.0 or later to be the default Ruby that you're
using

Then blindly run the following commands in your terminal:

```bash

bundle install
librarian-puppet install
vagrant up

```

### Using Jenkins

By default the Jenkins master machine isn't configured to be publicly
accessible because there isn't any authentication that will be set up. In order
to connect use SSH port forwarding:

    % vagrant ssh jenkinsmaster -- -L 8080:localhost:8080

Then open up [localhost:8080](http://localhost:8080/) in your web browser and
start using Jenkins!
