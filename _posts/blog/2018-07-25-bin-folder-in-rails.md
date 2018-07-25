---
layout: post
share: true
title: "Bin folder in rails"
modified: 2018-07-25T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-25T05:20:50-04:00
---

oAuth stands for open Authorization. Here an application delegates its responsibility of authenticating and 
authorizing a user to a third party application(such as Google, facebook, etc..).

1. Here user comes to the application.
2. Click the link of oAuth provider(Google or facebook)
3. Page gets redirected to that oAuth provider domain.
4. User provider the credentials there.
5. oAuth provider provides the an expirable token in return to the base application.
6. This token is then used by the base application to retrieve some of your information from that provider.

Main win situation for the user here is

1. User need not to provide its credentials(Google's or facebook's) to any random application.
2. User need not to create a separate account for that application and remember it for later use.

