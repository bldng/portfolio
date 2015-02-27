# Personal Portfolio

This is an experiment for a conversational interface, trying to filter the results to the user in a more or less natural way.

The frontend is a Hybrid static approach based on [roots.cx](http://www.roots.cx) and renders the compiled yaml-jade-templates without further server requests. Backend is an express app, filtering requests and generates messages based on [wit.ai](http://www.wit.ai) classifications.

The front end as of now is jquery madness, I am planning a better rewrite when I have more insights on how much functionality I have to add.

### roadmap

- angular or aurelia rewrite
- velocity js for animations
- music player / fav albums
- user history ("show * again")
- ~~generate menu when someone does not like the interface at all~~
- ~~"how are you" result~~
- clean logfiles
