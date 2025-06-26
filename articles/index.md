---
layout: page
title: "Articles Archive"
excerpt: "A comprehensive collection of technical articles and tutorials covering various programming topics."
search_omit: true
---

Welcome to the articles archive! Here you'll find a collection of technical articles covering various programming topics, tutorials, and insights.

## All Articles

<ul class="post-list">
{% for post in site.categories.articles %} 
  <li>
    <article>
      <a href="{{ site.url }}{{ post.url }}">
        <h3>{{ post.title }}</h3>
        <span class="entry-date">
          <time datetime="{{ post.date | date_to_xmlschema }}">
            {{ post.date | date: "%B %d, %Y" }}
          </time>
        </span>
        {% if post.excerpt %}
          <span class="excerpt">
            {{ post.excerpt | remove: '\[ ... \]' | remove: '\( ... \)' | markdownify | strip_html | strip_newlines | escape_once }}
          </span>
        {% endif %}
      </a>
    </article>
  </li>
{% endfor %}
</ul>

<p class="view-all-posts">
  <a href="{{ site.url }}/">← Back to Home</a>
</p>
