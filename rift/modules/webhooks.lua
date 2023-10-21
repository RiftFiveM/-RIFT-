local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/1162318846359785492/pQphhzHvcWGRlzWQzvy0pvDkSTHvubYp1yEFUhSx_174AiHmXIf6MLHldSffuQLlb0xp',
    ['leave'] = 'https://discord.com/api/webhooks/1162318846359785492/pQphhzHvcWGRlzWQzvy0pvDkSTHvubYp1yEFUhSx_174AiHmXIf6MLHldSffuQLlb0xp',
   -- -- civ
    ['give-cash'] = 'https://discord.com/api/webhooks/1162313343583924274/3ClFq9Otqjp0UECiSxxVv9hcXnzCrl0InjBccpvrRAzSM5A1mnORfj0sln88wV15FAQ',
    ['bank-transfer'] = 'https://discord.com/api/webhooks/1162313343583924274/3ClFq9Otqjp0UECiSxxVv9hcXnzCrl0InjBccpvrRAzSM5A1mnORfj0sln88wV15FAQ',
    ['search-player'] = 'https://discord.com/api/webhooks/1156656185085276160/zJ9WOT3ref4Exl-COUTSIAIcXOIqL4lva86bsOdD_2Ov4Gj7iT98Xgu3atd5qEt7dJ9',
    ['ask-id'] = 'https://discord.com/api/webhooks/1156656039031218298/wJ4nSGmgXQBRbQTZ2Feh5lTpTkOu6Tli9C78jHjFC3-2Taz-TrUpRcFP-b82fsLf1c',
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/1162319008012435486/75C1w953AnFUGD_WR7g5RQoagzcdaLLtSGIz77tV7Hv8Up5Xf8-cnIoAUyOp9MGW2nYU',
    ['twitter'] = 'https://discord.com/api/webhooks/1162319218419695696/SSYWDXIDU1jh5b7MLhKd2YBBCYm6QCV4hhCkc2lc3GdQlRfB7vGUscdEkWCdrueeW0oM',
    ['staff'] = 'https://discord.com/api/webhooks/1162319306521051157/kB58hlneuUtB3wxCgiuJl76dne8HSmYhpQiIIO23BCCjVXYmyaoUYg71nwyrUR0dAbZG',
    ['gang'] = 'https://discord.com/api/webhooks/1162319433147101244/oNi_iQfp1SP9ZzR8NYaGucGYT1E8ETU4td58tJE3D6ueL6U4Rxe7UCmWO2ejNfXJMt6Z',
    ['anon'] = 'https://discord.com/api/webhooks/1162320116084637777/XwwtJFgp4WmBcsWcs0iUgP-pBaDhEPgCSIE-IHt0S5W1rGRiS4EVsCaSmckkJ0wtcI5_',
   -- -- admin menu
    ['kick-player'] = 'https://discord.com/api/webhooks/1162320256728051752/jWlKRILGlvQDsl0CyKoyr73YiPkOTBs532KpXJrTsL4c-eqCysqWiw_0kA8lpfk2jWG8',
    ['ban-player'] = 'https://discord.com/api/webhooks/1162320379465969684/CVysRMZv9NQT9WAysekm21lFyOurFIZrDvjtoZohVewYVuSQYVUh_biY6ij4Zt-mphQS',
    ['spectate'] = 'https://discord.com/api/webhooks/1162320464425779200/-YC6wXaLg_oFrMkS9mgGmJh3J5ucTn_1T3X2GXoJ5t7hukcQ8gfiOPx2HyoO_tnixQTH',
    ['revive'] = 'https://discord.com/api/webhooks/1162320564220854315/3mjgOm1mGEvSFNuQ4fR7m7je7xbUsnCD50vR4-UgPX2-uJ4mfHg9ggpmU8SQ4By8Dsj6',
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/1156663589952831590/b_pd6Mz4OTE9FZcg9Nbw3yhGajoTQ2yRvm79uUPC3GYPgC2UBzBC3CjqMgTt1qgYRaIJ',
    ['tp-to-player'] = 'https://discord.com/api/webhooks/1162321501094162494/bNBi5FFTWL82MI6XRS3hMQYjuPwOOpFL-iPocyx0kmVTcl0R7SqVi8dbqyMlCt7cz17G',
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/1162321672632811571/_pYTdOD6-Ca2X7C-MR2X1DnsCOtX32JBmFv-gVtI2FfD2FNc2XMbNEb45p5ABMExG_wZ',
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/1162321796595449868/JnXr1AinaOxudQuNdajC1zhb8B0ZtQhGWiZI9vMaQBEOEAZZCRu-24t5ZxS807HBwquT',
    ['tp-to-legion'] = 'https://discord.com/api/webhooks/1162321889939685506/Ndwi_XYXbvwgVzzm5CClqZf90TgKw8rYmOlm_PhGEJWGVDkf7kOo0nRxIBz6AFXwFW0f',
    ['tp-to-simeons'] = 'https://discord.com/api/webhooks/1165172184566747238/OywORyWFgWzO7s5MkqOS5LBGu17NXD0Avk_nSYU7ENBdedgpNO7VZkx8uESSOepzpGWl',
    ['tp-to-Paleto'] = 'https://discord.com/api/webhooks/1162321971900596264/0eISb6UeGWiqd9hmfRFrsuD8QiTjTNEor0_uNnEV0CAASu-NA-_g_8JtYf1HS5NYrCUC',
    ['tp-to-casino'] = 'https://discord.com/api/webhooks/1165175292244013086/XobjtGt-PPTW7Q5_gqXaI9dOS5IicE4fqbiJY2gJWEpsU1wnz2vqK9W6N29XqPf7uwHw',
    ['tp-to-rebel'] = 'https://discord.com/api/webhooks/1165174404343418950/i0x76-t4rSqBxEE6t_LkQYfilB0_YtzyIB1OWyNYkmVfZFvdohqoPQCiLwLhJbI6cpnu',
    ['freeze'] = 'https://discord.com/api/webhooks/1162322059527987240/jf5C7ohns9e3fH2HUgB1EGmIbJzV2j-UWVmCuOexuB_s7Qk3-c9q9rJ8IlUbr-UsLl5Y',
    ['slap'] = 'https://discord.com/api/webhooks/1162322136204062771/3zC4LI-BRxmoEYDGlt9tHUJAbDGmOhz51REnX8eYSWLvrtyIypXKbGlAsHIjeAZeVmOZ',
    ['force-clock-off'] = 'https://discord.com/api/webhooks/1162322210845896764/374_fB1esdb8agrKuucn3tkW2n_S6QKRHVxA2MUT_PkqlCh8GCVA-DorykdkvqcXfM4Z',
    ['screenshot'] = 'https://discord.com/api/webhooks/1162322309382688768/WM1qIUjXEp_F9DFM56V6349uSmd6hqDqTAgGW9F9HERqFSJWyNKjjWGumFJWTlRtzJpe',
    ['video'] = 'https://discord.com/api/webhooks/1162322391188394088/C6hmJn8_bv9Ez6xLwQqaW9SS-mGMJknSB7LfBySst7QShjMeqmb-B3YU0E_PLZ5hRl8T',
    ['group'] = 'https://discord.com/api/webhooks/1162322463061987349/E8euJ65FhsF9ljqUVRHixOqk-YduwshSAdQnaYvmQkItD1K4YQprYrOKcTCUnyhZxzqH',
    ['unban-player'] = 'https://discord.com/api/webhooks/1162322535988338698/Sm-2NneZQIEe6yUEj0uxMejpZZraQqcwIbGGgPExSDdiXLfw39uurdbBFY_PeDCwaAvr',
    ['remove-warning'] = 'https://discord.com/api/webhooks/1162322613830422538/KKqDUdIP0B3pt-qe9ISYw-E_0PS9K6MGp4JlKPzJLz5zPzwflsUzcnoKlXEAtl_ROjoG',
    ['add-car'] = 'https://discord.com/api/webhooks/1162322707065606246/lAdZ8HsZv8ZDkvN4YZwfd_yyY9fcVplV5V2HyUU2aWfs9KIGk3WTMruRWrEuy0Ylvi6I',
    ['manage-balance'] = 'https://discord.com/api/webhooks/1162322788787433482/sd5CMXTacWl_d_x4PAcZuDOkSlamy1Cl5lKuqk_UBwAIIWJTght9MznSb8ZuycXqkPMK',
    ['ticket-logs'] = 'https://discord.com/api/webhooks/1162322891984089089/lsJ0snnown50nqQX4JgQhu5S1ymab9X4RHURA4D3pYy1GWVZBQ6mE6WxkBU1HVwC0WXF',
   -- ['com-pot'] = 'https://discord.com/api/webhooks/1132784487479120073/VSUZ09EmuzE7FhyvW3DKqmqogPWFwkAyV9JaXglx_GFd_qhg3QPsvHyzV9zVS-Shv0zA', (doesnt work)
   -- -- vehicles
    ['crush-vehicle'] = 'https://discord.com/api/webhooks/1162322983591886918/YZBoO7B65tWUzEh-7eDR2pD2fBCwSbfKKsKLr_jn8_q2Tpe8KCs6biozJgCEAsJbH7GF',
    ['rent-vehicle'] = 'https://discord.com/api/webhooks/1162323072473387028/Vb9N0IB6EzcwW2010iOQ6mDNyfzqR8N8LhMGkpuiC2pYugbWgct4SrEm-sydV3mXaVFq',
    ['sell-vehicle'] = 'https://discord.com/api/webhooks/1162323153075314769/a2l3WNH44gjK3dnzPROVgKZJ_4Fu-3cBUVEFTQkOrBbLiK1jJHxuKudALhJwKU-TQ7Hq',
   -- -- mpd
    ['pd-clock'] = 'https://discord.com/api/webhooks/1162324248136781895/Q1wW_03K56VLrYCxz_mmbezwtJCjPSeBx3FPlRICTCUl46nuQa9zUK9pH6bCh-zgR8sv',
    ['pd-afk'] = 'https://discord.com/api/webhooks/1162324345532719176/B80IHVuzP83ChiyFWZWMNFInvcoOLvn_-5vH3RlEN7AGpF9bye3U70cdPx2suA7bJIXj',
    ['pd-armoury'] = 'https://discord.com/api/webhooks/1162324418350026804/zLc_QliY7AT6_QJBzqdgXoqsPUxutEszIahb16dmoL15kaTM-jAqkqRi94zQFu7vcJOQ',
    ['fine-player'] = 'https://discord.com/api/webhooks/1162324490223624202/ocBwy_JYbg72nraYXDherhrozkcse7978A5SQ0xNv1_5_nBR8aapoNxJeVLOw6S6xlBs',
    ['jail-player'] = 'https://discord.com/api/webhooks/1162324613393547314/o5gavh5FgEzKGtkKFKOiv9c5-4BoCCo6nE2oFP12oNrIrM9zKS7AsqP8ONeVFUf4emCX',
    ['pd-panic'] = 'https://discord.com/api/webhooks/1162324703164256348/VHkv59maUv758RZxTwQoh6QAC9T7S9afNSi5gYgVFNpKCJbx4K_xDBhoYHK_-_-5yZp0',
    ['seize-boot'] = 'https://discord.com/api/webhooks/1162324779966144542/ZgfIXjVFQhqY6yZQAWek47FWX56fjU1vNNo-NfK4DZXi7WEh3u6DNrTfv3czapXYBUuL',
    ['impound'] = 'https://discord.com/api/webhooks/1162324852301103154/0DwmhHl1c-mPrGtEAzDJ50MF5F4qNGXjC4nBzgd1CLzxAj3gGr13FHhF7dYUlzHpizZq',
    ['police-k9'] = '',
   -- -- nhs
   -- ['nhs-clock'] = 'https://discord.com/api/webhooks/1154602772763783180/5550hrgjWpFs3momhjyjWA2pjoTW43YSE0L_yKGy_KZVYbGs3NHhnE5sM4M5CqkXn-QK',
   -- ['nhs-panic'] = 'https://discord.com/api/webhooks/1154602901818314865/ou-dEfbN9SOCUj6QMl-E__pRAvgc031-zZkzSE29PY_nOI6G1-7smm_y7UWSEkTUBwkd',
   -- ['nhs-afk'] = 'https://discord.com/api/webhooks/1154602997029019689/ATg-5JbyjmySH0QrZRFWqo1ETf0jtfyCsE2d-WKvTe-4jQFGYdevD0tv5i_nL7jc3L-C',
   -- ['cpr'] = 'https://discord.com/api/webhooks/1154603119750156289/U2WLc_5CdMOcd2mgE9TchakU7Cl15UlhkW35fP-zPh9dLR_A-XX7b-JOQWJON-Mtb7hK',
   -- -- licenses
    ['purchases'] = 'https://discord.com/api/webhooks/1162323257245040650/wnL8q5kmrKF33FVG0kQFHFOB4ptYts8zmxk5en8hNWVjBNjN5TnQnF-4y4U8J6qT0arN',
    ['sell-to-nearest-player'] = 'https://discord.com/api/webhooks/1162323257245040650/wnL8q5kmrKF33FVG0kQFHFOB4ptYts8zmxk5en8hNWVjBNjN5TnQnF-4y4U8J6qT0arN',
   -- -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1162323376648486975/maDX6OWgIHmoNRtEw2MExRzkaKMT1n8mj6qZpwA1X-ImTf0w7v7gmxATXpydrGqrdOLc',
    ['coinflip-bet'] = 'https://discord.com/api/webhooks/1162323951863746570/BEESj3tWF3iURU0VJSwE_5Zr1V6ZSMHRWprI02bU2vvP9Qtimk-D8c0Z0cJ41m173Lri',
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1162325206321348708/jh9znRTgcU1DSmHDVhzhu8Np7xucprRgQWShhpBK3NthBYN8hbsQy_alddiS2hqzsqnc',
    ['sell-chips'] = 'https://discord.com/api/webhooks/1162325316212113408/0uiviP-tbXyIggZIXpyVPlzWDEgF68QwI1zP9Wt54bs1OEgxnIvhIgWrQq7v59nu4FZ5',
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1162326465296224296/tzcyBGTE9dZEE2lJ0rhykJpxI4OXWB0Zbl__yo-SwnWWjzvUYbMOpGpkhRKfb9V8T0o4',
   -- -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1162326469503094854/5K2DLHy-FohpTzNkjMBZv6V36afbrtQfbcszOcM1N43nW1rEwJXQs3-lAzwwa_g5Dhup',
   -- -- housing (no logs atm)
   -- [''] = '',
   -- -- anticheat
    ['killvideo'] = "https://discord.com/api/webhooks/1162326473819050085/ED2Ohu2bznuOlZFnsJtxwn9OC_OC-b_lsPUxFbCIBW_DQjtkM7Cr1-_W2mbafSDQDd4m",
    ['anticheat'] = 'https://discord.com/api/webhooks/1162326478160138292/X9Dayuyx5tl7CkjRFJ4BvcRe8LEXVUvT9VXcfAHQTbTS78POdjb1WS-BZOtal7VmK6h0',
    ['ban-evaders'] = 'https://discord.com/api/webhooks/1162326478160138292/X9Dayuyx5tl7CkjRFJ4BvcRe8LEXVUvT9VXcfAHQTbTS78POdjb1WS-BZOtal7VmK6h0',
   -- -- dono
   -- ['donation'] = 'https://discord.com/api/webhooks/1132786663546949673/-7Y8sVGHowMvzfhaerPr0AG8sTQ9X17OmAC5razyy4T1ZjUADTiPHOvl39zC_xwcTTNt',
}

local webhookQueue = {}
Citizen.CreateThread(function()
   while true do
       if next(webhookQueue) then
           for k,v in pairs(webhookQueue) do
               Citizen.Wait(100)
               if webhooks[v.webhook] ~= nil then
                   PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                   end, "POST", json.encode({username = "RIFT Logs", avatar_url = 'https://cdn.discordapp.com/attachments/1151248692783878265/1151258300789293116/logo.png', embeds = {
                       {
                           ["color"] = 0x2596be,
                           ["title"] = v.name,
                           ["description"] = v.message,
                           ["footer"] = {
                               ["text"] = "RIFT - "..v.time,
                               ["icon_url"] = "https://cdn.discordapp.com/attachments/1151248692783878265/1151258300789293116/logo.png",
                           }
                   }
                   }}), { ["Content-Type"] = "application/json" })
               end
               webhookQueue[k] = nil
           end
       end
       Citizen.Wait(0)
   end
end)
local webhookID = 1
function tRIFT.sendWebhook(webhook, name, message)
   webhookID = webhookID + 1
   webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c")}
end

function RIFT.sendWebhook(webhook, name, message) -- used for other resources to send through webhook logs 
  tRIFT.sendWebhook(webhook, name, message)
end

function tRIFT.getWebhook(webhook)
   if webhooks[webhook] ~= nil then
       return webhooks[webhook]
   end
end