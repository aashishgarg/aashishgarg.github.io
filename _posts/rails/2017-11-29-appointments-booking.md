---
layout: post
share: true
title: "Appointments bookings feature through third party"
modified: 2017-11-29T08:20:50-04:00
categories: rails
excerpt:
tags: []
image:
  feature:
date: 2017-11-29T08:20:50-04:00
---

If your application requires an appointment booking functionality to be done through third party, 
then [timekit.io](https://developers.timekit.io/) is a very neat and efficient solution.
In one of my recent projects - Patients need to book different appointment slots for a doctor in iphone application 
which is implemented using timekit.

###### It provides basically following things
* An admin app to create bookings schedules.
* Frontend html for selecting appointment slots through its js widget - [booking.js](https://github.com/timekit-io/booking-js) 

###### Implementation logic
* Create an admin account on [timekit](https://admin.timekit.io/login).
* Create an application(under which all the service providers and their schedules will be created).
* It provides you a slug for your application created.
* Then in account settings - enable the developer mode to get the api token.
* Then configure the app settings in your application and create the resource(say doctor) and their calendar and schedule through timekit apis.
* Provide an api with provides a string of html in response which is created through booking.js
* Then your iphone application uses that provided html string and renders that html in InAppBrowser. From here all the appointment booking functionality works.
 
###### Implementation process followed in project 
* create a timekit.yml file in config folder

```yaml
development:
  email: timekit.admin.email@domain.com
  password: password
  appSlug: your_app_slug
  apiToken: your_app_api_token

staging:
  email: timekit.admin.email@domain.com
  password: Welcome@123
  appSlug: your_app_slug
  apiToken: your_app_api_token

production:
  email: timekit.admin.email@domain.com
  password: Welcome@123
  appSlug: your_app_slug
  apiToken: your_app_api_token
```

* Create an initializer

```ruby
TIMEKIT = YAML.load_file(File.join(Rails.root, 'config', 'timekit.yml'))[Rails.env]
```

* Now create a concern in model. On creation of doctor, a resource, its calendar and its 
projects(appointment scheduling) should get created. And on deletion of doctor, timekit 
resource should get deleted.

```ruby
module Timekit
  extend ActiveSupport::Concern

  included do
    before_create :create_resource, :create_calendar, :create_project
    after_destroy :delete_resource
  end

  def create_resource
    begin
      response = HTTParty.post(
          'https://api.timekit.io/v2/resources',
          basic_auth: {
              username: TIMEKIT['email'],
              password: TIMEKIT['apiToken']
          },
          headers: {
              'Content-Type': 'application/json',
              'Timekit-App': TIMEKIT['appSlug']
          },
          body: {
              email: self.email,
              timezone: 'America/Los_Angeles',
              name: self.first_name + (self.last_name.present? ? ' ' + self.last_name : ''),
              password: Doctor::PASSWORD
          }.to_json
      )
      if [200, 201].include?(response.code)
        self.timekit_resource = response['data'].to_h
        self.timekit_project = Doctor::DEFAULT_TIMEKIT_PROJECT_ID
      else
        raise ActiveRecord::Rollback, response['errors']
      end
    rescue => e
      self.errors.add(:email, 'TimeKit Error -> '+e.message)
      throw(:abort)
    end
  end

  def create_calendar
    begin
      response = HTTParty.post(
          'https://api.timekit.io/v2/calendars',
          basic_auth: {
              username: self.email,
              password: self.timekit_resource['api_token']
          },
          headers: {
              'Content-Type': 'application/json',
              'Timekit-App': TIMEKIT['appSlug']
          },
          body: {
              name: self.email,
              description: "#{self.email} CALENDAR"
          }.to_json
      )

      if [200, 201].include?(response.code)
        self.timekit_calendar = response['data'].to_h
      else
        raise ActiveRecord::Rollback, response['errors']
      end
    rescue => e
      self.errors.add(:email, 'TimeKit Error -> '+e.message)
      delete_resource
      throw(:abort)
    end
  end

  def create_project
    begin
      response = HTTParty.post(
          'https://api.timekit.io/v2/projects',
          basic_auth: {
              username: self.email,
              password: self.timekit_resource['api_token']
          },
          headers: {
              'Content-Type': 'application/json',
              'Timekit-App': TIMEKIT['appSlug']
          },
          body: {
              name: self.email,
              slug: self.email.split('@').first.gsub('.', '-').gsub('+', '-'),
              config: {
                  email: self.email,
                  calendar: self.timekit_calendar['id'],
                  apiToken: self.timekit_resource['api_token'],
                  app: TIMEKIT['appSlug'],
                  timekitFindTime: {
                      filters: {
                          or: [{
                                   specific_day_and_time: {
                                       day: "Monday",
                                       start: 1,
                                       end: 9,
                                       timezone: "America/Los_Angeles"
                                   }
                               },
                               {
                                   specific_day_and_time: {
                                       day: "Tuesday",
                                       start: 1,
                                       end: 9,
                                       timezone: "America/Los_Angeles"
                                   }
                               },
                               {
                                   specific_day_and_time: {
                                       day: "Wednesday",
                                       start: 1,
                                       end: 9,
                                       timezone: "America/Los_Angeles"
                                   }
                               },
                               {
                                   specific_day_and_time: {
                                       day: "Thursday",
                                       start: 1,
                                       end: 9,
                                       timezone: "America/Los_Angeles"
                                   }
                               },
                               {
                                   specific_day_and_time: {
                                       day: "Friday",
                                       start: 1,
                                       end: 9,
                                       timezone: "America/Los_Angeles"
                                   }
                               },
                               {
                                   specific_day_and_time: {
                                       day: "Saturday",
                                       start: 1,
                                       end: 9,
                                       timezone: "America/Los_Angeles"
                                   }
                               },
                               {
                                   specific_day_and_time: {
                                       day: "Sunday",
                                       start: 1,
                                       end: 9,
                                       timezone: "America/Los_Angeles"
                                   }
                               }]
                      },
                      length: "30 minutes"
                  }
              }
          }.to_json
      )
      if [200, 201].include?(response.code)
        self.timekit_project = response['data']['id']
      else
        raise ActiveRecord::Rollback, response['errors']
      end
    rescue => e
      self.errors.add(:email, 'TimeKit Error -> '+e.message)
      delete_resource
      delete_calendar
      throw(:abort)
    end
  end

  def delete_resource
    HTTParty.delete(
        "https://api.timekit.io/v2/resources/#{self.timekit_resource['id']}",
        basic_auth: {
            username: TIMEKIT['email'],
            password: TIMEKIT['apiToken']
        },
        headers: {
            'Timekit-App': TIMEKIT['appSlug']
        }
    )
  end

  def delete_calendar
    HTTParty.delete(
        "https://api.timekit.io/v2/calendars/#{self.timekit_calendar['id']}",
        basic_auth: {
            username: TIMEKIT['email'],
            password: TIMEKIT['apiToken']
        },
        headers: {
            'Timekit-App': TIMEKIT['appSlug']
        }
    )
  end

  def decline_appointment
    response = HTTParty.post(
        'https://api.timekit.io/v2/bookings/58190fc6-1ec0-4ebb-b627-7ce6aa9fc703/confirm',
        basic_auth: {
            username: self.email,
            password: self.timekit_resource['api_token']
        },
        headers: {
            'Content-Type': 'application/json',
            'Timekit-App': TIMEKIT['appSlug']
        },
        body: {
            name: "Doctor's Appointment Calendar",
            description: "'Doctor's Appointment Calendar description'"
        }.to_json
    )
  end

  def appointment_html_snippet(patient, payment_source_id)
    <<EOS
      <html>
        <head></head>
        <body>
        <div id='bookingjs'>
            <script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>
            <script type='text/javascript' src='https://cdn.timekit.io/booking-js/v1/booking.min.js' defer></script>
            <script type='text/javascript'>window.timekitBookingConfig = {
                app: '#{TIMEKIT['appSlug']}',
                email: '#{self.email}',
                apiToken: '#{self.timekit_resource['api_token']}',
                calendar: '#{self.timekit_calendar['id']}',
                name: '#{self.first_name}',
                avatar: '#{Rails.application.config.action_mailer.default_url_options[:host]}#{self.avatar.url}',
                widgetId: '#{self.timekit_project}',
               
                timekitCreateBooking: {
                    graph: 'instant',
                    action: 'confirm',
                    customer: {
                        email: '#{patient.email}',
                        source_id: #{payment_source_id},
                        patient_id: #{patient.id}
                    }
                },

                bookingFields: {
                  name: {
                    placeholder: 'Name',
                    prefilled: '#{patient.first_name || ''}',
                    locked: false
                  },
                  email: {
                    placeholder: 'Email',
                    prefilled: '',
                    locked: false
                  },
                  comment: {
                    enabled: true,
                    placeholder: 'Comment',
                    prefilled: false,
                    required: false,
                    locked: false
                  },
                  phone: {
                    enabled: true,
                    placeholder: 'Phone Number',
                    prefilled: '#{patient.phone_number}',
                    required: false,
                    locked: false
                  }
                },

                localization: {
                  strings: { 
                    allocatedResourcePrefix: 'with',
                    submitText: 'Book Appointment',
                    successMessageTitle: 'Thanks!',
                    successMessageBody: 'Appointment confirmed!',
                    timezoneHelperLoading: 'Loading..',
                    timezoneHelperDifferent: 'Your timezone is %s hours %s of %s (calendar shown in your local time)',
                    timezoneHelperSame: 'You are in the same timezone as %s'
                  }
                }
            };</script>
        </div>
        </body>
      </html>
EOS
  end
end
```

* Now include this module in your Doctor model.

```ruby
include Timekit
```

*  Now on creation of doctor, valid login on timekit gets created with Doctor::PASSWORD. After login in app
through doctor, under project section, scheduling of that doctor can be configured.

* Now provide an api which responds with HTML string with all the settings done.

```ruby
  def new
    @doctor = Doctor.find_by_id(params[:id])
    if @doctor           
        render json: {
            appointment_html: @doctor.appointment_html_snippet(current_user, @source.id)
        }      
    else
      render json: {errors: {doctor: 'not found'}, message: 'Doctor not found.'}, status: :not_found unless @doctor
    end
  end
```

* Now iphone should consume this html and show it in InAppBrowser.
