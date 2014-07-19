# Domo-url

URL module for [Domo-kun](https://github.com/rikukissa/domo)

## What does it do?
It listens for messages including URL addresses and tries to fetch the title of the page.
`````
11:27 riku-: http://www.youtube.com/watch?v=9JOIj88PGGI
11:27 Domo: Domo Kun - The Piano - YouTube
`````

## How to use
`````
npm install domo-url
`````

After this you can just add domo-url to Domo's config or load it on runtime by using __!load__ command if you basic routes are enabled!

## Changelog

### 0.2
* Uses [url-to-title](https://github.com/rikukissa/url-to-title) module for fetching urls

### 0.1
* Now uses request and iconv-lite to handle crawling/encoding.
* ### Breaking changes
    * Only works with domo-kun >=0.2.


## License

The MIT License (MIT)

Copyright (c) 2014 Riku Rouvila

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
