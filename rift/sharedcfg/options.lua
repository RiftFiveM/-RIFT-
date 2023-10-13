RIFTConfig = {} -- Global variable for easy referencing. 

RIFTConfig.MoneyUiEnabled = true; -- Set to false to disable Money in the top right corner. 
RIFTConfig.SurvivalUiEnabled = true; -- Controls the UI under the healthbar.
RIFTConfig.EnableComa = true; -- Controls the RIFT coma on death.
RIFTConfig.EnableFoodAndWater = true; -- Controls the food and water system.
RIFTConfig.EnableHealthRegen = true; -- Controls the health regen. (Whether they regen health after taking damage do not disable if coma is enabled.)
RIFTConfig.EnableBuyVehicles = true; -- Enables ability to buy vehicles from the RageUI Garages.  
RIFTConfig.LoadPreviews = true; -- Controls the car previews with the RageUI Garages.
RIFTConfig.VehicleStoreRadius = 250; -- Controls radius a vehicle can be stored from.
RIFTConfig.AdminCoolDown = false; -- Enables an admin cooldown on call admin.
RIFTConfig.AdminCooldownTime = 60; -- 1 minute in (seconds) duration of cooldown. 
RIFTConfig.StoreWeaponsOnDeath = true; -- Stores the players weapon on death allowing them to be looted.
RIFTConfig.DoNotDisplayIps = true; -- Removes all RIFT related references in the console to player ip addresses.
RIFTConfig.LoseItemsOnDeath = true; -- Controls whether you lose inventory items on death.
RIFTConfig.AllowMoreThenOneCar = false; -- Controls if you can have more than one car out.
RIFTConfig.F10System = true; -- Logs warnings and can be accessed via F10 (Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/rift_punishments)
RIFTConfig.ServerName = "RIFT" -- Controls the name that is displayed on warnings title etc.
RIFTConfig.PlayerSavingTime = 3000 -- Time in milliseconds to update Player saving
RIFTConfig.Status = 'Development' -- Development, Whitelisted, Online
---------------
RIFTConfig.LootBags = true; -- Enables loot bags and disables looting. 
RIFTConfig.DisplayNamelLootbag = false; -- Enables notification of who's lootbag you have opened
RIFTConfig.Purge = false;
