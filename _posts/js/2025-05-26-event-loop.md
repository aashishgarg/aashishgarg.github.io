---
layout: post
share: true
title:  "Understanding the JavaScript Event Loop"
categories: js
tags: [javascript, event-loop, async, webdev]
---

The **JavaScript Event Loop** is one of the most fundamental concepts to understand when working with asynchronous operations in the browser or Node.js.

---

## What is the Event Loop?

JavaScript is single-threaded, meaning it can only do one thing at a time. To handle asynchronous tasks without blocking the thread, JavaScript uses a system involving:

- **Call Stack**
- **Web APIs**
- **Callback Queue (Task Queue)**
- **Microtask Queue**
- **Event Loop**

---

## Visual Diagram

```

+-------------------+
\|   Call Stack      |
+-------------------+
▲
|
+-------------------+       +--------------------+
\| Microtask Queue   | <---> | Callback Queue     |
+-------------------+       +--------------------+
▲                        ▲
\|                        |
+-------------------+       +--------------------+
\|    Web APIs       |       | User Events (e.g., click)
+-------------------+       +--------------------+

````

---

## Descriptive Code Example

```javascript
console.log("Start");

setTimeout(() => {
  console.log("Timeout");
}, 0);

Promise.resolve().then(() => {
  console.log("Promise");
});

console.log("End");
````

**Expected Output:**

```
Start
End
Promise
Timeout
```
