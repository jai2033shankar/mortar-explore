## Mortar Explore 

Mortar Explore is a plugin for the [Mortar Gem](https://github.com/mortardata/mortar). It provides instant feedback about what is happening in your Pig script. On save, Mortar Explore will illustrate your data and feed the results to a local webpage.

### Installation ###

Before getting started make sure you already have [Mortar installed](http://help.mortardata.com/reference/mortar_project_reference/install_mortar_development_framework).

```
$ gem install bundler
$ mortar plugins:install https://github.com/mortardata/watchtower.git
```

### Usage ###

To start exploring your results:

```
$ mortar watch RESULTS_DIRECTORY
```

The RESULTS_DIRECTORY should be where the pigscript stores all the recsys results.  Should reference the out directory as mortar explore is meant to look into both the item_item_recs and user_item_recs

It is also best to store the item-item recs in a directory as item_item_recs and the user-item recs in a directory as user_item_recs.  This follows the examples given in mortar-recsys project

### Development ###


To help develop Mortar Explore, make sure you have the latest version of the Mortar Gem. Then clone this repo and run:
```
$ bundle install --standalone
```
Once completed, run:

```
$ rake watch
```

This will start a file watcher over the Mortar Explore repo, any changes will cause the rake script to reinstall the plugin. If for whatever reason your installation of Mortar Explore breaks, you can uninstall it by running:

```
$ rake clean
```

### Known Issues ###

* Explore hangs for up to 30 seconds when exiting on Ruby 1.8.7. This has something to do with the Thin server not closing out the connections. We've tried using our own signal trapping, but it doesn't seem to work.
