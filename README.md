# kitchen-local
Plugin for [test-kitchen](https://github.com/test-kitchen/test-kitchen), which runs directlry against the current, local machine.

It helps you to run kitchen converge in a virtualized CI environment with a configuration consistent to other test-kichen environments, for example.

## Kitchen Configuration
```yaml
driver:
  name: local
transport:
  name: local

# Often you have installed test-kitchen as a part of ChefDK
# thus you already have chef commands.
provisioner:
  require_chef_omnibus: false
  chef_solo_path: chef exec bundle exec chef-solo
```
