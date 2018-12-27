---
layout: post
share: true
title: "JS plugin ScrollPaginator of pagination on page scroll"
modified: 2017-02-23T08:20:50-04:00
categories: rails
excerpt:
tags: []
image:
  feature:
date: 2017-02-23T08:20:50-04:00
---

Pagination is a basic requirement for any page showing the listing of the items.

One that can be implement with js is presented below -  

```javascript
ScrollPaginator.VISIBILITIES = ['TOP', 'COMPLETE'];

function ScrollPaginator(options) {
    this.options = {
        object_visibility: 'TOP',
        total_pages: 0    };
    $.extend(this.options, options);

    this.sample_element = $('<div id="sample_object" class="sample_object"></div>');
    $(this.sample_element)
        .height(this.options.item.height()).width(this.options.item.width())
        .attr('class', $(this.sample_element).attr('class') + this.options.item.attr('class'));

    this.last_loaded_page = 1;
    this.request_next = true;
}

ScrollPaginator.prototype = {
    provision: function () {
        this.sample_element.attr('class', this.options.item.attr('class'));
        this.options.item.parent().append(this.sample_element)
    },

    validVisibility: function () {
        $.inArray(this.options.object_visibility, ScrollPaginator.VISIBILITIES)
    },

    increment_page: function () {
        this.last_loaded_page += 1;
        if (this.last_loaded_page >= this.options.total_pages) {
            this.last_loaded_page = this.options.total_pages;
        }
    },

    decrement_page: function () {
        this.last_loaded_page -= 1;
        if (this.last_loaded_page <= 1) {
            this.last_loaded_page = 1;
        }
    },

    activateOnScrollPagination: function () {
        var _this = this;
        $(window).unbind('scroll');
        $(window).bind('scroll', function () {
            _this.loadItems();
        });
    },

    isSampleVisible: function () {
        var docViewTop = $(window).scrollTop();
        var docViewBottom = docViewTop + $(window).height();
        var elemTop = $(this.sample_element).offset().top;
        var elemBottom = elemTop + $(this.sample_element).height();
        switch (this.options.object_visibility) {
            case 'TOP':
                return ((elemTop <= docViewBottom) && (elemTop >= docViewTop));
                break;
            case 'COMPLETE':
                return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
                break;
            default:
                console.log('Visibility option is not valid.');
                return false;
        }
    },

    loadItems: function () {
        var _this = this;
        if (this.isSampleVisible()) {
            if (this.request_next) {
                if (this.last_loaded_page < this.options.total_pages) {
                    this.increment_page();

                    /*--- For preventing multiple requests ---*/                    
                    this.request_next = false;

                    $.ajax({
                        method: 'GET',
                        dataType: 'script',
                        url: this.options.items_source_url + '?page=' + _this.last_loaded_page
                    }).success(function () {
                        _this.request_next = true;
                        _this.loadItems();
                    }).fail(function () {
                        _this.decrement_page();
                    });
                } else {
                    this.request_next = false;
                }
            }
        }
    },

    enable: function () {
        this.provision();
        this.activateOnScrollPagination();
        this.loadItems();
    }
};
```
