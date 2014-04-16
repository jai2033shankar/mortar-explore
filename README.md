## Mortar Explore

Mortar Explore is a plugin for the [Mortar Gem](https://github.com/mortardata/mortar). It is custom built for participants for the self-serve recommender program.  However, it is being extended for all mortar users!


### Installation 

Before getting started make sure you already have [Mortar installed](http://help.mortardata.com/reference/mortar_project_reference/install_mortar_development_framework).

```
$ gem install bundler
$ mortar plugins:install https://github.com/mortardata/mortar-explore.git
```

### Usage 

To start exploring your results:

```
$ mortar explore  RESULTS_DIRECTORY
```

The RESULTS_DIRECTORY should be where the pig script stores all the recsys results (don't point to an actual file as mortar explore will automatically look for the part file).

#### Mortar Recsys Specific 

Mortar explore has a mode specific for viewing [recommendation results.](http://help.mortardata.com/recommendation_engine_tutorial/landing_page/recommendation_engine_tutorial_overview.html) This time, run:
```
$ mortar explore RESULTS_DIRECTORY/item_item_recs -r
```
This mode only works when viewing your item_item_recs so point directly to that directory.  Note that the dash `-r` sets up mortar explore to view recommendation results. When you look at the browse and search page, you will notice that there is a details button.  Click it and you can see recommendations for an item in greater detail.

In the details page, you can see that the bottom has configuration settings that need to be set.  *Ensure that you add `http://` in front of the url!!*   These are urls that lead to your own applications where the images of your items are located and the pages of your item are located.  Each url will use the item id to identify the exact image or page to render.  The code looks for `#{id}` in the url to replace the id with.  To later change the url, go into the application, click an item and you will see a configuration section.  Hit the button and it will automatically update your default URLs.

You also need to set the corresponding columns to match your data output.  You need to set the selected item, the recommended item IDs, and the rank of the recommended item.  

For default, set Selected Item to 'column1', Recommended Item to 'column2' and Rank to 'column5'

### Mortar Explore Example

Begin by downloading the [mortar-explore-demo](https://github.com/mortarcode/mortar-explore-demo).  Go to the root of the project and run:
```
$ mortar explore data/books/out/item_item_recs/ -r
```

When prompted for an Image URL and Item URL, enter:
```
http://images.amazon.com/images/P/#{id}
```
And for item URL, enter:
```
http://www.amazon.com/s?ie=UTF8&field-isbn=#{id}
```



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
