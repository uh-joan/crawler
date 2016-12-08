#Simple Web Crawler

Given a starting URL, it visits every reachable page under that domain, up to a given depth.

For each page, it determines the URLs of every static asset (images, javascript, stylesheets) on that page.

The crawler outputs to STDOUT in JSON format listing the URLs of every static asset, grouped by page.

```
For example:
[
  {
    "url": "http://www.example.org",
    "assets": [
      "http://www.example.org/image.jpg",
      "http://www.example.org/script.js"
    ]
  },
  {
    "url": "http://www.example.org/about",
    "assets": [
      "http://www.example.org/company_photo.jpg",
      "http://www.example.org/script.js"
    ]
  },
  ..
]
```

# Depth

The depth determines the links to reach, for example:

```
- Depth 0
  http://www.example.org

- Depth 1
  http://www.example.org/about
  http://www.example.org/contact
  http://www.example.org/faq
  http://www.example.org/blog

- Depth 2
  http://www.example.org/blog/news
  http://www.example.org/faq/english
  http://www.example.org/faq/french
```

# Usage
```
Usage: web_crawler [options]
    -u, --url URL                    The url to crawl
    -d, --depth DEPTH                The depth of the links to reach
    -h, --help                       Show this message
```