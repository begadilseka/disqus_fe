'use strict';

# this script is used in background.html

chrome.runtime.onInstalled.addListener (details) ->
  console.log('previousVersion', details.previousVersion)

chrome.browserAction.setBadgeText({text: '0'})

Stat =
  data: {}
  cur: null

tabChanged = (url) ->
  if Stat.cur
    lst = Stat.data[Stat.cur]
    lst.push("seka1")

  console.log Stat.data

  [d, other] = url.split '://'
  [domain, oth] = other.split '/'
  urlN = d + "://" + domain

  Stat.cur = urlN
  lst = Stat.data[urlN] or []
  lst.push("seka")
  Stat.data[urlN] = lst

seka = (url)->
  [d, other] = url.split '://'
  [domain, oth] = other.split '/'
  urlN = d + "://" + domain

  lst = Stat.data[urlN]
  if not lst
    return 0

  [d, other] = url.split '://'
  if d not in ['http', 'https']
    return 0

  res = 1

  return res

updateBadge = (url)->
  res = seka url
  chrome.browserAction.setBadgeText({text: "#{res}"})

chrome.tabs.onActivated.addListener (activeInfo)->
  Stat.curTabId = activeInfo.tabId
  chrome.tabs.get activeInfo.tabId, (tab) ->
    tabChanged(tab.url) if tab.url
    updateBadge tab.url
