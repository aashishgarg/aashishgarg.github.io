---
layout: post
share: true
title: "Save image uploaded from mobile devices to server(base64)"
modified: 2016-06-02T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2016-06-02T08:20:50-04:00
---

Yesterday there was a requirement where user wanted to uploaded his/her profile pic from mobile application.

There are two basic ways of doing that -

1. Image will be directly uploaded to s3 bucket on aws and url will be provided to the server.
2. base64 string of that image will be provided to the server.

*Base64 - represents binary data in an ASCII string format by translating it into radix-64 representation. 
Each base64 digit represents 6 bits of data.*

Base64 module in ruby provides encoding and decoding of binary data using a Base64 representation.

Here mobile device provides an image as base64 string to server and then server decodes that string back to form the 
same image.

```ruby
  base64_string = Base64.encode64(File.join(Rails.root, 'public', 'hello.png'))
```

```
# -> "
data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFoAAABaCAMAAAAPdrEwAAAAb1BMVEX/mQD/////mAD/lAD/
kgD/pj7/lgD/sWH/jwD/+/X/mg3/9uv/8eT/v3z/9Oj/3bv/5s3/xoz/7dv/ozn/woP/16//rVH/oB7/yJL/zZ3/4cH/s
Fn/6dP/06n/t2n/nBr/nyn/tnH/p0n/u3H/rEj0TROTAAAFLElEQVRYha2ZfYOyIAzAEYhEs6ysy8r06vn+n/4cnAr/X/
DeT2nENbihAAAAABJRU5ErkJggg=="
```

Then manipulation of this base64 string on server would be like - 

```ruby
_profile_data = base64_string.match(/\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/) || []
_profile_image_data = _profile_data[2]
extension = MIME::Types[_profile_data[1]].first.preferred_extension

tempfile = File.join(Rails.root, 'tmp', "#{ SecureRandom.uuid}.#{extension}")
File.open(tempfile, "wb") do |file|
  file.write(Base64.decode64(_profile_image_data))
end
self.profile_pic = File.open(tempfile)
File.delete(tempfile) if File.exists? tempfile
```
