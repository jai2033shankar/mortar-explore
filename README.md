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
$ mortar explore  RESULTS_DIRECTORY
```

The RESULTS_DIRECTORY should be where the pigscript stores all the recsys results.  Should reference the out directory as mortar explore is meant to look into both the item_item_recs and user_item_recs

It is also best to store the item-item recs in a directory as item_item_recs and the user-item recs in a directory as user_item_recs.  This follows the examples given in mortar-recsys project


The second use of Mortar Explore is to voyage (it is a little more adventurous than explore) into your S3 bucket.  This can be done by running:

```
$ mortar voyage S3_BUCKET
```

This will run the same interface to browse through your results.

### Development ###


To help develop Mortar Explore, make sure you have the latest version of the Mortar Gem. Then clone this repo and run:
```
$ bundle install --standalone
```
Once completed, you need to use ruby 1.8.7 to run rake.  So ensure you are using with rvm by running:
```
$ rvm use 1.8.7
```
Then run:

```
$ rake watch
```

This will start a file watcher over the Mortar Explore repo, any changes will cause the rake script to reinstall the plugin. If for whatever reason your installation of Mortar Explore breaks, you can uninstall it by running:

```
$ rake clean
```

### Known Issues/TODO ###

* Validation for confirming if it is an s3 bucket or is a directory
* ability to move from one part file to the next
* ability to set configuration of output
