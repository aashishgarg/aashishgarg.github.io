---
layout: post
title: "Active admin cheat-sheet in Rails"
modified:
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-10-15T08:20:50-04:00
---

#### Active Admin cheatsheet in Rails 

Hello rails newbies.
Almost every application, be it a Rails application or other technology application, it requires an admin application 
from where admin can View/Create/Delete/Update the different resources available in the applications.

Rails provides different Gems for the admin application like - Active admin and Rails admin.

These are the application which require a setting at the minimum level and provides the functionalities at the maximum 
of it. Active admin is best to provide the admin functionalities in Rails applications.

My personal suggestion to master active admin is just don't go with its official documentation in the very first place. 
Just go to its site and configure the a application and then you will get an the idea by yourself everything.  
Then you will start to understand the active admin documentation by yourself.


##### In my application, I first configured it then started to understand it.

1. For every model CRUD functionality is provided very easily and effectively.
2. Different rails gems can be easily configured in active admin.
3. And the most important one, There is nothing that cannot be done in Active admin.

###### Configurations

* Add gem in Gemfile.

```ruby
  gem 'activeadmin', github: 'activeadmin'
```

* Run installer command for generating active admin configuration file in config/initializers. 

```
  rails generate active_admin:install
```

* Create a resource for a model in active admin folder 

```
  rails generate active_admin:resource model_name
```

 *For every resource a page will be created in admin folder in app folder of the application.*
 

**Now you just need to apply different settings and it starts behaving according to your requirements.**

* Menu

```ruby
  menu priority: 2
```              

* Permitted params

```ruby
  permit_params :name, :parent_id, :best_seller, :latest
```

* Pagination size

```ruby
  config.per_page = 10
```              

* Scopes

```ruby
  scope :root_categories
```              

* Filters

```
  filter :name
```              

* Override Form (New/Edit)

```ruby
form do |f|
  f.inputs 'Categories and sub categories form' do    
  f.semantic_errors
    f.input :parent_id, :label => 'Root category', as: :select2,
            collection: Category.root_categories.collect { |category| [category.name, category.id] }
    f.input :name
    if f.object.sub_category?
      f.input :latest, as: :boolean      
      f.input :best_seller, as: :boolean    
    end  
  end  
  f.actions
end
```

* Override Index page

```ruby
index do  selectable_column
  id_column
  column :name do |category|
    if category.sub_category?
      label category.name.capitalize, class: 'sub_category_label'    
    else      
      label category.name.capitalize, class: 'root_category_label'    
    end  
  end  
  column :root_category  
  column :total_items, sortable: true do |category|
    if category.sub_category?
      label category.items.count
    else      
      label category.sub_categories.collect { |x| x.items.count }.inject(&:+)
    end  
    
  end  
  column :created_at do |category|
    time_ago_in_words(category.created_at) + ' ago'  
  end  
  column :updated_at do |category|
    time_ago_in_words(category.updated_at) + ' ago'  
  end  
  actions
end
```

* For converting all the drop downs of the application into select2 drop downs add gem.

```ruby
  gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'
```

*  For changing theme of the application add gem.

```ruby
  gem 'active_admin_theme'
```

* For adding Import functionality add gem.

```ruby
  gem "active_admin_import" , '3.0.0'
```

* For editing values in the index page add gem.

```ruby
  gem 'best_in_place', github: 'bernat/best_in_place'
```

### Thanks
