#1
#text mode
db.posts.find()
#text mode
db.posts.find().pretty()
#2
db.posts.find({title: /NoSQL/})
#3
db.posts.find({$or: [{title: /NoSQL/}, {description: /NoSQL/}]})
#4
db.posts.find({"tags": "mongodb"})
#5
db.posts.find({likes: {$gt: 50}})
#6
db.posts.find().sort({likes: -1})
#7
db.posts.aggregate([{$group: {_id: null, avgLikes: {$avg: "$likes"}}}])
#8
db.posts.find({comments: {$elemMatch: {date: {"$month": 2, "$year": 2014}}}})
