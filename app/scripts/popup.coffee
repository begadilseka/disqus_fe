'use strict';

# this script is used in popup.html

# array of comments
comments = [] 

# used to determine is reply button is clicked
isReply = false

# create ractive
ractive = new Ractive
     el : '#result'
     template : '#ractive_id'
     data :
         user_name: ''
         user_email: ''
         comments:comments

# set array length to 0
ractive.set 'array_length',0

# set replied author to ''
ractive.set 'reply_to',""

# hide show more button
document.getElementById('show_more').style.display = 'none'

# method which runs when ok button is clicked
ractive.on 'ok', =>

  # get user credentials and save to localStorage
  ractive.set 'user_name',ractive.get 'user_name'
  ractive.set 'user_email',ractive.get 'user_email'

  chrome.storage.local.get 'value',(result) ->
    result = result.value
    result.user_name = ractive.get 'user_name'
    result.user_email = ractive.get 'user_email'
    chrome.storage.local.set {'value':result}

# method which runs when reply button is clicked
ractive.on 'reply', (
  (event,item,i) ->
    id = 'n' + i

    # get name from h4 with given id
    name = document.getElementById(id).innerHTML

    # add name to comment field
    ractive.set 'comment',name+", "

    # set ractive reply_to to name
    ractive.set 'reply_to',name

    # used to determine is reply button is clicked
    isReply = true
    0
)

# method which runs when show more button is clicked
ractive.on 'show_more', =>
  # hide show more button
  document.getElementById('show_more').style.display = "none"
  a = (ractive.get 'array_length')
  for i in [2...a]
    # show comments with gived id
    id = 'div' + i
    document.getElementById(id).style.display = "block"


# method which runs when add button is clicked (add comment)
ractive.on 'add_comment', =>
  # get current date
  date = new Date()
  
  # get current date day and add 0 if day is less than 9 (8 -> 08, 1 -> 01)
  day = date.getDate()
  day = '0' + day if day <= 9
  
  # get current date month and add 0 if month is less than 9 (8 -> 08, 1 -> 01)
  month = date.getMonth()
  month = '0' + month if month <=9

  # show alert if user credentials are not fully entered
  if (ractive.get 'user_name') == '' || (ractive.get 'email') == ''
  	alert('enter name and surname to add comment')
  	return

  # get avatar from gravatar.com and put it to as comment author avatar
  ractive.set 'ava',(md5 (ractive.get 'user_email'))
  comments = ractive.get 'comments'

  # used to determine is this comment is just comment or reply to comment
  reply_to_s = ""
  if isReply
  	reply_to_s = ractive.get 'reply_to'

  # get data and put it to comments array
  comments.push({
           name:ractive.get 'user_name'
           ava:ractive.get 'ava'
           email:ractive.get 'user_email'
           reply_to:reply_to_s
           comment:ractive.get 'comment'
           date:day+'.'+month+'.'+date.getFullYear()
       })

  # save comments to ractive to print it on popup.html
  ractive.set 'comments',comments

  # save comments length to show how many comments on popup.html
  ractive.set 'array_length',comments.length

  # clean comment input
  ractive.set 'comment',''

  # used to determine is reply button is clicked
  isReply = false

  # show/update how many comments on current url
  chrome.browserAction.setBadgeText {text: comments.length.toString()}

  # update data
  chrome.storage.local.get 'value',(result) ->
    # get saved data from localStorage
    result = result.value
    chrome.tabs.getSelected null,(tab)->

      # get from url only domain and protocol
      [d, other] = (tab.url).split '://'
      [domain, oth] = other.split '/'
      urlN = d + '://' + domain
      
      flag = false

      # get saved data from localStorage
      urls = result.urls

      for val in urls
      	# check is current url is equals to saved url
        if urlN == val.url
          # if equals just update
          result.urls[_i].comments = ractive.get 'comments'
          chrome.storage.local.set {'value':result}
          chrome.browserAction.setBadgeText {text: val.comments.length.toString()}
          ractive.set 'array_length',val.comments.length.toString()
          flag = true
          break
      if !flag
      	# if current url is not equals to any saved urls create new urls array and save to main array
        urls.push({
              url:urlN
              comments:comments
          });
        dannye =
          user_name:ractive.get 'user_name'
          user_email:ractive.get 'user_email'
          urls:urls
            
        chrome.storage.local.set {'value':dannye}
      
      # show all comments
	  a = (ractive.get 'array_length') - 1
	  if a > 2
	    document.getElementById('show_more').style.display = "none"
	    for i in [2...a]
	      id = 'div' + i
	      document.getElementById(id).style.display = "block"


chrome.storage.local.get 'value',(result) ->
  # get saved data from localStorage and set user credentials and comments count
  result = result.value
  ractive.set 'user_name',result.user_name
  ractive.set 'user_email',result.user_email
  ractive.set 'array_length',(ractive.get 'comments').length
  
  chrome.tabs.getSelected null,(tab)->

    # get from url only domain and protocol
    [d, other] = (tab.url).split '://'
    [domain, oth] = other.split '/'
    urlN = d + '://' + domain
    
    flag = false

    # get saved data from localStorage
    urls = result.urls

    for val in urls
      # check is current url is equals to saved url
      if urlN == val.url
        # if equals set comments counts and and comment list from localStorage to ractive
        ractive.set 'comments',result.urls[_i].comments
        chrome.browserAction.setBadgeText {text:val.comments.length.toString()}
        ractive.set 'array_length',(result.urls[_i].comments).length
        flag = true
        break
    if !flag
      # if current url is not equals to any saved urls set badge text to 0
      chrome.browserAction.setBadgeText {text:'0'}

    # get comments array length and check
    a = (ractive.get 'array_length')
    if a > 2
      # if comments array length > 2 then show only 2 comments, others hide
      document.getElementById('show_more').style.display = "block"
      document.getElementById('show_more_text').innerHTML = "show other " + (a - 2) + " comments"
      for i in [2...a]
      	id = 'div' + i
      	document.getElementById(id).style.display = "none"
