'use strict';

# this script is used in popup.html

comments = []

ractive = new Ractive
     el : '#result'
     template : '#ractive_id'
     data :
         user_name: ''
         user_email: ''
         comments:comments

ractive.set 'array_length',0
document.getElementById('pager').style.display = 'none'
name = ractive.get 'user_name'
email = ractive.get 'user_email'
document.getElementById('add_comment').disabled = true if name.length < 1
document.getElementById('add_comment').disabled = true if email.length < 1

ractive.on 'ok', =>
  name = ractive.get 'user_name'
  email = ractive.get 'user_email'

  document.getElementById('add_comment').disabled = true if name.length < 1
  document.getElementById('add_comment').disabled = true if email.length < 1

  if name.length > 0 && email.length > 0
  	ractive.set 'user_name',ractive.get 'user_name'
  	ractive.set 'user_email',ractive.get 'user_email'
  	document.getElementById('add_comment').disabled = false
  0

ractive.on 'add_comment', =>
  date = new Date()
  
  day = date.getDay()
  day = '0' + day if day <= 9
  
  month = date.getMonth()
  month = '0' + month if month <=9

  name = ractive.get 'user_name'
  email = ractive.get 'user_email'
  comment = ractive.get 'comment'

  document.getElementById('add_comment').disabled = true if name.length < 1
  document.getElementById('add_comment').disabled = true if email.length < 1

  if name.length > 0 && email.length > 0
  	comments = ractive.get 'comments'
  	comments.push({
            name:name
            email:email
            comment:ractive.get 'comment'
            date:day+'.'+month+'.'+date.getFullYear()
        })
  	ractive.set 'comments',comments
  	ractive.set 'array_length',comments.length
  	ractive.set 'comment',''
  	document.getElementById('pager').style.display = 'block' if comments.length > 1
  0