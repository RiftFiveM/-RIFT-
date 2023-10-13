--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

RegisterNetEvent("RIFT:twitter_getTweets")
AddEventHandler("RIFT:twitter_getTweets", function(tweets)
  SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("RIFT:twitter_getFavoriteTweets")
AddEventHandler("RIFT:twitter_getFavoriteTweets", function(tweets)
  SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("RIFT:twitter_newTweets")
AddEventHandler("RIFT:twitter_newTweets", function(tweet)
  SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
end)

RegisterNetEvent("RIFT:twitter_updateTweetLikes")
AddEventHandler("RIFT:twitter_updateTweetLikes", function(tweetId, likes)
  SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("RIFT:twitter_setAccount")
AddEventHandler("RIFT:twitter_setAccount", function(username, password, avatarUrl)
  SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent("RIFT:twitter_createAccount")
AddEventHandler("RIFT:twitter_createAccount", function(account)
  SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("RIFT:twitter_showError")
AddEventHandler("RIFT:twitter_showError", function(title, message)
  SendNUIMessage({event = 'twitter_showError', message = message, title = title})
end)

RegisterNetEvent("RIFT:twitter_showSuccess")
AddEventHandler("RIFT:twitter_showSuccess", function(title, message)
  SendNUIMessage({event = 'twitter_showSuccess', message = message, title = title})
end)

RegisterNetEvent("RIFT:twitter_setTweetLikes")
AddEventHandler("RIFT:twitter_setTweetLikes", function(tweetId, isLikes)
  SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)



RegisterNUICallback('twitter_login', function(data, cb)
  TriggerServerEvent('RIFT:twitter_login', data.username, data.password)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
  TriggerServerEvent('RIFT:twitter_getTweets')
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
  TriggerServerEvent('RIFT:twitter_getFavoriteTweets')
end)

RegisterNUICallback('twitter_postTweet', function(data, cb)
  TriggerServerEvent('RIFT:twitter_postTweets', data.message)
end)

RegisterNUICallback('twitter_postTweetImg', function(data, cb)
  TriggerServerEvent('RIFT:twitter_postTweets', data.username or '', data.password or '', data.message)
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
  TriggerServerEvent('RIFT:likeTweet',data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
    TriggerServerEvent("RIFT:setTwitterAvatar", data.avatarUrl)
end)
