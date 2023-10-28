local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/1167247512533483590/33Ryz7OgcKNsrnQ-hJL0sZJChP_TXazfj4JAa_LS59ziEq5_ELNwUiSWmTvac8uksQLe',
    ['leave'] = 'https://discord.com/api/webhooks/1167247579319373824/nVHyCWhY_GArVkw44LA1cQS9WdGedtXeWYONFGhyA0wC1nNIYit9eJrq_C1TbpXxbkel',
   -- -- civ
    ['give-cash'] = 'https://discord.com/api/webhooks/1167247649620111391/f2_1YUoY8bUEgH1pPtt6BMZP24ubGnrsE-S26eAzZGVY9MZEsNBPODuuxBOW_4oe_bcH',
    ['bank-transfer'] = 'https://discord.com/api/webhooks/1167247712819888170/-rXyT7camn_m_4eUZw5xhSQ0ynSWC-THAMXWSxkvezhazKytZY7WRJ6Oku18-KBqGVZy',
    ['search-player'] = 'https://discord.com/api/webhooks/1167247784173375549/qD7iHAHIc9x2dAqZN98sG-6oNfRsVn92uOXsfGzBab-LH3U55ttmhfV0TCb0uRcBFGNv',
    ['ask-id'] = 'https://discord.com/api/webhooks/1167247861914808340/NB3MxZhSAFMyJvZCqLDw9pQm5NFE6VmkONSrPw5m_Z59E8uMaxGvnSUkGGKE7LzCbbd3',
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/1167247932026794155/xGjAoSkyaJZFODzrcH-Osp5XsgLumklThrtyzyNmHyI8J0rygl3KtPVbng4IYX4WNPhc',
    ['twitter'] = 'https://discord.com/api/webhooks/1167248010175074415/A3faThqOwNBV9iLwpGUezZxszbzw00WPnqcASiYNB8nZBPLl8QZAMkJrU8DrncvLIjFc',
    ['staff'] = 'https://discord.com/api/webhooks/1167248082019295242/41Tyqq5XLsjecCr4O1nkbpoSZcACMiULZ3CvzYo7mMetQotLAJFyjBPGI-CGJZ3ji3wX',
    ['gang'] = 'https://discord.com/api/webhooks/1167248146942935110/6eiSd8civ03QSJCp5hAiw0Gv6Tvwy5NECOB11_IpRnlEJrsknwJyNwp3k3SW4bKANUkB',
    ['anon'] = 'https://discord.com/api/webhooks/1167248213435240510/_X5hzgoRRp5eHWysvvOlsKyjMG8XZmvEDxwiXbDag3CBKykQsNIkKYqSerRtAALT8s9O',
   -- -- admin menu
    ['kick-player'] = 'https://discord.com/api/webhooks/1167248445061484744/VXbeoEhrBWzwSMjhILm-K6tsVMcrQHqGbtCteP_s22wev6FjJu9rctSrx4-Zv4xefhdY',
    ['ban-player'] = 'https://discord.com/api/webhooks/1167248501953007616/p0hjZ30d5wPYh9r4Jrc8ywepI_5Y26O9yK_1YaevXNdaW8EqPsWlRhT-T88AyeqXWMlN',
    ['spectate'] = 'https://discord.com/api/webhooks/1167248571670745128/SuihIzQfHUWOoKvsLcJhpQ4PcKruSbKGMh9d4WQIk6n_tkbib-U-NHx5swkdRtXV4xED',
    ['revive'] = 'https://discord.com/api/webhooks/1167248825426129026/XgCLvyLwqevGnw6lsFMX3ZcFlM4MJJ-CQU77xlb36irDVp7zytITUUQFf12upCWsotxY',
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/1167248978862149722/WThLapsYiosnONu698qoO97-PdAR9pZXQh0aowDGjEIPlmucwanIE51phhVhKfCCqd2H',
    ['tp-to-player'] = 'https://discord.com/api/webhooks/1167249043806765216/OvaBPcxFhq2UYhuTrg05X_di60uN7AZigOzc6D3OO0D1OXixk2au79zCD8qjMvJktLgd',
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/1167249132780539955/eih1nEMj1NdsC7FQWdKf44mURQ_2r894MRytFVWwoOF-z8feQThcxgH8RVN3Fy4mWtWq',
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/1167249220470853652/KQE2eaFTplv8mJz0JPhL8RBGeHYE4n7F3KodklOKP7AqcK8wP9-7f_QxaU5nirU4FuGx',
    ['tp-to-legion'] = 'https://discord.com/api/webhooks/1167249342529286194/ThtWDsmR-lUpmAeBtAlokWOEGYr66ClcZzf8Ei2zSeZUfxJz2ksu73lDj3Z324WvmxV-',
    ['tp-to-simeons'] = 'https://discord.com/api/webhooks/1167249412477702184/me3dsNZHeliUeBjdHuatXL_sNM_WWj6yxChBe4LQtuYCsfGqOkh73sHEYDieca1-yAQY',
    ['tp-to-Paleto'] = 'https://discord.com/api/webhooks/1167249494572810250/avRg6Q_uFhpxAnmsNXUFuclWwwtYoT2WFXqMYyGPUYLZqt95_ICPo9nOvSorKrODve0O',
    ['tp-to-casino'] = 'https://discord.com/api/webhooks/1167249575434780822/iCSBg5GJj_E-KR3H1Sn5cHqwxYAX9rCC-j6UmkSS4nlyoRVqDwMRzGFpVx5xbfjqq4J3',
    ['tp-to-rebel'] = 'https://discord.com/api/webhooks/1167249654002503801/oBa4BnYtpKVpimnuPsKw4jzxcBeZ4QN7hg0FGeC1FczpZ46ZASUgV0UY0478icERCNP6',
    ['freeze'] = 'https://discord.com/api/webhooks/1167249756624535612/tL_7pWG8UPmyA8kPTq-zxI2TX9YeIj0qBQtpNLLdagQ0Pp2PCgfbVdJsjwaY0ff0ZNto',
    ['slap'] = 'https://discord.com/api/webhooks/1167249834927980665/uBAaE-t01-Ifvk2R_4or2V4gtrgWkjsH8SnLpiMJdezAG6Fb-fbPJVYJRhvS2PlHsW5A',
    ['force-clock-off'] = 'https://discord.com/api/webhooks/1167249936140730461/h-wXRPSkGXxI_WOU5z3YkA0oF1y05bRkfZ9HBDoolUPTZvgdmtLckXKtva2JwgOkDQF5',
    ['screenshot'] = 'https://discord.com/api/webhooks/1167250016709115947/mTOUdjrlgQU3eD9u0jn_sWfsv0mQbImdjVAnCVnUz8KVlnRRoG0lDxr0ePXEV-zUuF-e',
    ['video'] = 'https://discord.com/api/webhooks/1167250091854266409/dRzWJ9NacCR-XKkTOMCCQf4pUUtgK2E8qEDc8DqON6ihm3LS17YrVBoEwd9rP6BnOhoh',
    ['group'] = 'https://discord.com/api/webhooks/1167251746620452885/Qd3emwD8Z9MF7gNBX9cgg8M_H0eXBZjgcCCtRO1xWbavj3BXW1vR_a4oDTn4Q30CIgxk',
    ['unban-player'] = 'https://discord.com/api/webhooks/1167255372143284355/I6fqSCU0FM11X7ZAHheIX7jbGtwfJSnUOYFyzHiEevQOrm6KfhmE3Z1LOnw8S1jMvHTT',
    ['remove-warning'] = 'https://discord.com/api/webhooks/1167255486329000038/JthqK6ONjc4QOTh9T4OXVN_3P2t2kHJjJhzTr1UFF0COR-dr_BaGWgScwNEFD76FhuM1',
    ['add-car'] = 'https://discord.com/api/webhooks/1167255562585636904/M4y0CTZtP8kT2a5tLsd5gFzyX785tXGOpX3C7iQ8Lg-OB1XBVtA4usZUu1DZu7jyKvP6',
    ['manage-balance'] = 'https://discord.com/api/webhooks/1167255632622145617/I7Jn9g8dXmqbrazKPwABuuujX7D0G11qCB4k-SIzY0Cm_NHchEeieB065LTgq4ZiVJjP',
    ['ticket-logs'] = 'https://discord.com/api/webhooks/1167257442057453698/lVuwrIWU1rSrkIimk016cD7qxzZGBXlRFwZYNwcWdsJvWRrtQEsrlvUKbuEpzxln8o08',
   -- ['com-pot'] = 'https://discord.com/api/webhooks/1167257543261814905/m2a-4INqSuWyGNkEodXwSkN6iEE8Qh8vFrSsc5M3amv9RSHsRTk1Ovk12brpBzJ1ZiCc', (doesnt work)
   -- -- vehicles
    ['crush-vehicle'] = 'https://discord.com/api/webhooks/1167257631203799100/LmEgpcnskNwLBz_MBEsBPCIxdz0RbvIdifiAfA0at7H0TBCWH40gjCPN3gy3_yvnrJmT',
    ['rent-vehicle'] = 'https://discord.com/api/webhooks/1167261648730464397/FDSG2UxxbI629puYnjHDrSs9OD76dfEqKavrcIFp_-kjhnjl0YxhR6fruZatClTTNaEG',
    ['sell-vehicle'] = 'https://discord.com/api/webhooks/1167261725700137031/N4hG4ngPoGps72doTnKMx98JiYF0VxNQQvKZFwPuAPPAFjyfEMuHUHOf23kluqSDqZej',
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
    ['purchases'] = 'https://discord.com/api/webhooks/1167261807547777084/OcxgAaKx_z_MbKo4M3854m_YVJILnxaWKMuV7NwEr8Hg3ACnPAbpVUAtEtpaHbNkoXSs',
    ['sell-to-nearest-player'] = 'https://discord.com/api/webhooks/1167261923331543110/Q9IW8pXABN0lF-Ww1-L3BsPZrlQpaXL11AyFskqivtkpYvks43aZnvFgnfpYYT22nAD2',
   -- -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1167262012724748338/Rwgingo0JYbIjWzKyHFLdDSakKy__5AAjBJaTGsNS1rf6AvAdnJPkvY32YpoBsLMQVgX',
    ['coinflip-bet'] = 'https://discord.com/api/webhooks/1167262071151411291/cfBLNdYqrIj7YnSLqlQdHz5lSK6pi_saBpeSoGlBt4PAHAy55T55zfHssQqaln9XF0hz',
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1167262148364357642/jWmw9H_zRTa_lnasFXm0XCAmu-GSnOppOux6y4mS6xOzzrgnO1CJytGwX1k48F2jIkzQ',
    ['sell-chips'] = 'https://discord.com/api/webhooks/1167262229796753531/d7Su36MiSy7qhObwTOGHh9flJf8y3wrjMw1prgadeNyClN1h5T5iXeAD0YzlaTZ5jGxE',
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1167263540021842020/sgO9Bxgx_Zc9-inEJqJcPtlyOeE9aN_a48PWchhbFD63FuuX6SXR-hTogefY-7U5rp7U',
   -- -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1167264387971686480/huZZCyT12ETEbADm5z-UTIfA00gu6HhqCX-QEoH0CwSqV8N1ysW3VuU4ZKBm1GF4mju7',
   -- -- housing (no logs atm)
   -- [''] = '',
   -- -- anticheat
    ['killvideo'] = "https://discord.com/api/webhooks/1167264458645708810/99PaNX7LyvnGlUUFmap2MA5zRE_J-LRjM4VRkO6VXp0iBuH8om86nGROJE1r8iqmMaKu",
    ['anticheat'] = 'https://discord.com/api/webhooks/1167271369768189962/vvVX9OgIPhYgBFDGIEpb8v2Uj7L-UjGV04qSeC3lZ5i-rE3BuPgOEM1mfcM3Do5OPZqT',
    ['ban-evaders'] = 'https://discord.com/api/webhooks/1167271489637187646/Ug8Gj0w9tfdAaJyQNHHRhpvEfqE38a6VjQVRwwPd0JNkq64WxQacZfQyRxhfORdFAi6H',
   -- -- dono
   -- ['donation'] = 'https://discord.com/api/webhooks/1167271565205979176/VQje2QD-GqBhQ7eI_Xi8O14mo2xb8t06bLG7BtYMpkB8-UxzXREFkxZR-VSCjzAtf8Pf',
}

local webhookQueue = {}
Citizen.CreateThread(function()
   while true do
       if next(webhookQueue) then
           for k,v in pairs(webhookQueue) do
               Citizen.Wait(100)
               if webhooks[v.webhook] ~= nil then
                   PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                   end, "POST", json.encode({username = "Polar Logs", avatar_url = 'https://cdn.discordapp.com/attachments/1151248692783878265/1151258300789293116/logo.png', embeds = {
                       {
                           ["color"] = 0x2596be,
                           ["title"] = v.name,
                           ["description"] = v.message,
                           ["footer"] = {
                               ["text"] = "Polar - "..v.time,
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
function tPolar.sendWebhook(webhook, name, message)
   webhookID = webhookID + 1
   webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c")}
end

function Polar.sendWebhook(webhook, name, message) -- used for other resources to send through webhook logs 
  tPolar.sendWebhook(webhook, name, message)
end

function tPolar.getWebhook(webhook)
   if webhooks[webhook] ~= nil then
       return webhooks[webhook]
   end
end