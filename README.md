## Simple Responsive

A mobile-ready [Phyxo](http://www.phyxo.net) theme based on [Piwigo Bootstrap Darkroom](https://github.com/tkuther/piwigo-bootstrap-darkroom)

![alt tag](https://raw.githubusercontent.com/nikrou/simple-responsive/master/screenshot.png 'Simple Responsive screenshot')

### Features

-   Various color styles
    -   [Bootswatch](https://bootswatch.com)
    -   [Material Design](http://fezvrasta.github.io/bootstrap-material-design/)
    -   Darkroom: a dark, low contrast color scheme based on Lightroom® colors (the default)
-   Optional page header with fancy fading full width background image, or a jumbotron banner
-   Different layout option for the picture details page
-   Video support using native HTML 5 video widget
-   Fullscreen slideshow view using [PhotoSwipe](http://photoswipe.com)
    -   Supports auto play
    -   Supports HTML5 video
    -   Album thumbnails can be linked to PhotoSwipe directly (like smartpocket)
-   Configurable carousel album navigation on the picture page using [slick slider](http://kenwheeler.github.io/slick/)
-   100% mobile ready
    -   fully responsive Navbars, Carousel, PhotoSwipe slideshow, video content
    -   async/ondemand loading of carousel & PhotoSwipe content, adaptive image size selection, swipe & tap events
-   Various configuration options
-   Easy customization using CSS overrides or SASS custom build for advanced needs.

### Usage

1.  Installation:

-   Use the Phyxo built-in plungin manager (preferred)
-   or git clone and move to phyxo/themes/simple-responsive
-   or download from https://ext.phyxo.net/extension_view.php?eid=5

2.  Enable Simple Responsive

### Demo

A demo is available at https://demo.phyxo.net

### Documentation, Support and Issue tracker

-   [Issue tracker](https://github.com/nikrou/simple-responsive/issues)

### Components

-   [Bootstrap 4](https://getbootstrap.com)
-   [Bootswatch](https://bootswatch.com)
-   [Bootstrap Material Design](https://fezvrasta.github.io/bootstrap-material-design/)
-   [PhotoSwipe](http://photoswipe.com/)
-   [Slick](http://kenwheeler.github.io/slick/)
-   [jQuery-Touch-Events](https://github.com/benmajor/jQuery-Touch-Events)
-   [Photography Icons](https://thenounproject.com/DmitryBaranovskiy/collection/photo/) by [Dmitry Baranovskiy](https://thenounproject.com/DmitryBaranovskiy/), licensed under [Creative Commons 3.0](https://creativecommons.org/licenses/by/3.0/us/)

### Development & Customizing

-   All stylesheets are compiled from Bootstrap's Sass source files using node-sass.
-   Dependencies are managed using npm.
-   To install build dependencies, use

```
npm install
```

The build process is based on npm scripts and uses common shell functions, so it might not work on Windows.

To build everything, use

```
npm run build
```

To build only bootswatch, for example, use

```
npm run build:bootswatch
```

See [package.json](https://raw.githubusercontent.com/nikrou/simple-responsive/master/package.json) for available script commands.

There is built-in support for a custom Sass build.

-   Create the file _scss/custom/custom.scss_
-   Include all required Boostrap stuff in there, override variables as you wish, just like any custom bootstrap build
-   Compile with `npm run build:custom`
-   Select "Custom" style in the theme's configuration
