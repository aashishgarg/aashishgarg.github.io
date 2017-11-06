---
layout: post
title: ".xlsx file upload in rails"
modified:
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-05-23T08:20:50-04:00
---

Its a day to solve some data uploading trick from an .xlsx file in Rails. xlsx file contains different sheets in it and each sheet has rows and columns.

All the data resides in these rows and columns of different sheets.

Data of the rows is provided as array of arrays.

Let's have a situation where we have a xlsx file with different sheets(quality, travel, basic_key) and each sheet contains first row as different languages and then in other rows it has different word and their different meanings in all languages.

Here we need to retrieve the data from this file and have to save the data in our database.

###### Let's  directly come to the main points. 

* Gem used  -   'roo', '~> 2.7.0'
* Here we follow the philosophy that we show be aware about the first language in advance then from that access the header row and then corresponding data. 

* We have the category classes as - Categories::Quality,  Categories::Travel etc.
* And the corresponding table names - categories_qualities, categories_travels.

* Code on the model for handling - 

```ruby
require 'roo'
class AdminUser < ApplicationRecord
  # ============== Devise options ==================== #  
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  # ============== Attribute accessors =============== #  
  attr_accessor :uploaded_file
  
  # ============== Instance Methods ================== #  
  def starting_point(sheet, first_column_header)
    starting_point = {row: -1, column: -1} #--> Invalid starting point    
    sheet.first_row.upto(sheet.last_row).each do |row_no|
      sheet.row(row_no).length.times do |column_no|
        if sheet.row(row_no)[column_no] == first_column_header          
          _row_no = row_no
          # ---- If the column name is repeated in rows for header description ---- #          
          _row_no = row_no + 1 if sheet.row(row_no + 1)[column_no] == first_column_header          
          _column_no = column_no
          starting_point[:row] = _row_no + 1 #---> _row_no provides header row no.          
          starting_point[:column] = _column_no          
          return starting_point        
        end      
      end    
    end    
    starting_point #--> If no matching header column found  
  end

  def sheet_object(sheet_name)
    self.uploaded_file.sheet(sheet_name)
  end

  def valid_sheets(first_column_header='English')
    valid_sheets = []
    self.uploaded_file.sheets.each do |sheet_name|
      unless starting_point(self.uploaded_file.sheet(sheet_name), first_column_header) == {row: -1, column: -1}
        valid_sheets << sheet_name      
      end    
    end    
    valid_sheets  
  end

  def valid_sheet_categories    
    valid_sheets.map { |sheet_name| "Categories::#{sheet_name.titleize.gsub(' ', '').singularize}".classify.constantize }
  end

  def category_table_names(first_column_header='English')
    valid_sheets(first_column_header).map { |sheet_name| 'categories_'+sheet_name.titleize.gsub(' ', '').underscore.pluralize }
  end

  def valid_category_names(first_column_header='English')
    valid_sheets(first_column_header).map { |sheet_name| sheet_name.titleize.gsub(' ', '').underscore.singularize }
  end

  def sheet_category(sheet_name)
    "Categories::#{sheet_name.titleize.gsub(' ', '').singularize}".classify.constantize
  end

  def sheet_headers_columns(sheet, first_column_header='English')
    _start_point = starting_point(sheet, first_column_header)
    headers = []
    _start_point[:column].upto(sheet.last_column).each do |column_no|
      headers << sheet.row(_start_point[:row] -1)[column_no].titleize.gsub(' ', '').underscore if !!sheet.row(_start_point[:row] -1)[column_no]
    end    
    headers  
  end

  def upload_data(first_column_header='English')
    valid_sheets(first_column_header).each_with_index do |sheet_name, index|

      # ================== Delete all data of table ================== #      
      sheet_category(sheet_name).delete_all

      sheet = self.uploaded_file.sheet(sheet_name)
      _headers = sheet_headers_columns(sheet, first_column_header)

      _row = starting_point(sheet, first_column_header)[:row]
      _column = starting_point(sheet, first_column_header)[:column]

      # ================== Populating dictionary data in table ======== #      
     _row.upto(sheet.last_row).each do |row_no|
        _hash ={}
        _headers.each_with_index do |_header, _index|
          # If sheet column name is a          
            if sheet_category(sheet_name).column_names.include?(_headers[_index])
            _hash.merge!("#{_headers[_index]}" => (sheet.row(row_no)[_column + _index]))
            end        
        end        
        sheet_category(sheet_name).create(_hash)
      end    
    end  
   end
end
```

* Now create the roo file object for uploaded xlsx file

```ruby
  current_user.uploaded_file = Roo::Excelx.new(params[:file].path)
```

And its done!!!

Thanks !!!
