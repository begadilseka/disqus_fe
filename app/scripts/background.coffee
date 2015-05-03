'use strict';

# this script is used in background.html

chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)

# main array of data
dannye =
  user_name:''
  user_email:''
  urls:
    [
      url:''
      comments:
        [
          name:''
          ava:''
          email:''
          reply_to:''
          comment:''
          date:''
        ]
    ]
                
# when extension is runs first time or updates save clean main array of data to localStorage   
chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)
  chrome.storage.local.set {'value': dannye}


# method for update badge text when tab changes
update= =>
  # get saved data from localStorage
  chrome.storage.local.get 'value',(result)->
    result = result.value
    chrome.tabs.getSelected null,(tab)->
      
      # get from url only domain and protocol
      [d, other] = (tab.url).split '://'
      [domain, oth] = other.split '/'
      urlN = d + '://' + domain
      
      flag = false
      urls = result.urls
      
      for val in urls
        # check is current url is equals to one of the saved urls
        if urlN == val.url
          # if equals get counts of comments and update
          chrome.browserAction.setBadgeText {text:val.comments.length.toString()}
          flag = true
          break
      if !flag
        # if current url is not equals to any saved urls set badge text to 0
        chrome.browserAction.setBadgeText {text:'0'}

update()

# runs when user changes tab and shows update method
chrome.tabs.onActivated.addListener (activeInfo)->
  update()
