---
layout: post
share: true
title: "Bootstrap modal manipulations made easy in Rails"
modified: 2017-12-06T08:20:50-04:00
categories: rails
excerpt:
tags: []
image:
  feature:
date: 2017-12-05T08:20:50-04:00
---

### Bootstrap modal
Modal is a kind of popup provided by bootstrap. But generally its a kind of clumsy task to handle different
manipulations on it. 

#### How we handle modal in application efficiently

* Add the HTML code of modal in the layout file - _app/views/layouts/application.html.erb_

```html
<div class="modal fade modal-window custom-popup" id="modal-window" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title"> Modal title </h3>
      </div>
      <div class="modal-body custom-body">
        <div class="modal-body"><p>Modal body</p></div>
      </div>
      <div class="modal-footer">Modal footer</div>
    </div>
  </div>
</div>
```

* Now add a js file in - _app/assets/javascripts/show_modal.js_

```javascript
function showModal(options) {
    console.log('options');
    if (options.animation == false) {
        $('.modal').removeClass('fade');
    }
    if (options.dialog_class) {
        $('.modal').find('.modal-dialog').addClass(options.dialog_class);
    }
    if (options.extra_class) {
        $('.modal').find('.modal-header').addClass(options.extra_class);
        $('.close').hide();
    }
    if (typeof(options.title) == 'undefined') {
        $('.modal').find('.modal-header').hide();
    } else {
        $('.modal').find('.modal-header').show();
        $('.modal').find('.modal-title').html(options.title);
    }
    if (typeof(options.footer) == 'undefined') {
        $('.modal').find('.modal-footer').hide();
    } else {
        $('.modal').find('.modal-footer').html(options.footer).show();
    }
    $('.modal').find('.modal-body').html(options.content);
    $('.modal').modal();

    if (typeof(options.callback_on_hidden) == 'function') {
        $('.modal').off('hidden.bs.modal').on('hidden.bs.modal', options.callback_on_hidden);
    }
    if (typeof(options.callback_on_shown) == 'function') {
        $('.modal').off('shown.bs.modal').on('shown.bs.modal', options.callback_on_shown);
    }
    $('.modal').on('hidden.bs.modal', function () {
        if (options.animation == false) {
            $('.modal').addClass('fade');
        }
        $('.modal').find('.modal-dialog').removeClass(options.dialog_class);
        $('.modal').find('.modal-header').removeClass(options.extra_class);
    });
}
```


* Now you just need to call the **showModal(options)** on the event you want where you want to show the modal anywhere 
in your application.

```javascript
showModal({
                title: 'Modal Title',
                content: $('<div>Modal Body</div>'),
                footer: 'Modal Footer',
                extra_class: 'extra_class_to_be_added_on_modal-header_div',
                callback_on_shown: function () {
                    console.log('JS code to be executed after the modal is shown')
                },
                callback_on_hidden: function () {
                                    console.log('JS code to be executed after the modal is closed')
                                }
            });
```

Doing this you will find the modal handling a fun in your application.

Thanks for reading!!!
