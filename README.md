# Zelzele

An iOS app to monitor seismic activity in Turkey.

## Why?

I built Zelzele just to play with [Kimono Labs](http://www.kimonolabs.com), a mind-blowing service to do data-scraping.

## Building
In order to build Zelzele yourself:

* [Sign up](http://www.kimonolabs.com/signup) for a Kimono Labs account.
* Go to the [earthquake-tr API](http://www.kimonolabs.com/apis/de82dvke) on Kimono. There you'll see an API key generated for you under the “How to use” tab.
* Open a terminal in ````Zelzele/Zelzele```` then do

	````
	echo '#define API_KEY @"<YOUR API KEY HERE>"' > API_KEY.h
	````

The ````API_KEY.h```` file is gitignored so no one accidentally pushes his API key. That being said, this is most probably not the best method to handle this, so feel free to issue a pull request if you'd suggest a better way.


