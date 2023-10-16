cfg = {
	Guild_ID = '1162343507579654214',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '1162343507579654214', 
		['Police'] = '1162471723850022912', 
		['NHS'] = '115457820004792732',
		['HMP'] = '115460086115939956',
		--['LFB'] = '1008206756226277477',
  	},
	RoleList = {},

	CacheDiscordRoles = false, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 1162343507780964399, -- 12
		['Lead Developer'] = 1162343507780964397, -- 11
		['Developer'] = 1162343507780964396, -- 10
		['Community Manager'] = 1162343507780964395, -- 9
		['Staff Manager'] = 1162343507780964394, -- 8
		['Head Administrator'] = 1162343507780964393, -- 7
		['Senior Administrator'] = 1162343507764203529, -- 6
		['Administrator'] = 1162343507764203528, -- 5
		['Senior Moderator'] = 1162343507764203527, -- 4
		['Moderator'] = 1162343507764203525, -- 3
		['Support Team'] = 1162343507764203524, -- 2
		['Trial Staff'] = 1162343507764203523, -- 1
		['cardev'] = 1157871123137048698,
	---	['Cinematic'] = 1162343507579654219,
		['Supporter'] = 1162343507642552341,
		['Premium'] = 1162343507642552342,
		['Supreme'] = 1162343507642552343,
		['Kingpin'] = 1162343507642552344,
		['Rainmaker'] = 1162343507642552345,
		['Baller'] = 1162343507642552346,
	},

	['Police'] = {
        ['Commissioner'] = 1162471724131045413,
        ['Deputy Commissioner'] = 1162471724131045412,
        ['Assistant Commissioner'] = 1162471724131045411,
        ['Dep. Asst. Commissioner'] = 1162471724131045410,
        ['Commander'] = 1162471724131045409,
        ['Chief Superintendent'] = 1162471724110069796,
        ['Superintendent'] = 1162471724110069795,
        ['Chief Inspector'] = 1162471724072316996,
        ['Inspector'] = 1162471724110069795,
        ['Sergeant'] = 1162471724072316991,
        ['Special Constable'] = 1162471724131045406,
        ['Senior Constable'] = 1162471724072316990,
        ['PC'] = 1162471724072316989,
        ['PCSO'] = 1162471724072316989,
        ['Large Arms Access'] = 1162471724072316991,
        ['Police Horse Trained'] = 1162471723891961895,
        ['Drone Trained'] = 1162471724072316989,
        ['NPAS'] = 1162471723938099465,
        ['Trident Officer'] = 1162471723963269137,
        ['Trident Command'] = 1162471723963269137,
        ['K9 Trained'] = 1162471723891961893,
    },

--	['NHS'] = {
  --  ['NHS Head Chief'] = 1154587532454006814,
--	['NHS Assistant Chief'] = 1154587469300367470,
  --  ['NHS Deputy Chief'] = 1154587528091930684,
--	['NHS Captain'] = 1154587466892845150,
--	['NHS Consultant'] = 1154587501772685413,
--	['NHS Specialist'] = 1154587495514779758,
--	['NHS Senior Doctor'] = 1154587472341250099,
--	['NHS Doctor'] = 1154587513793552504,
--	['NHS Junior Doctor'] = 1154587475264675981,
--	['NHS Critical Care Paramedic'] = 1154587494399082497,
--	['NHS Paramedic'] = 1154587503353925632,
	--['NHS Trainee Paramedic'] = 1154587505006477362,
---	['Drone Trained'] = 1154587499985899520,
---	['HEMS'] = 1154587464724402176,
---	},

	-- -- ['HMP'] = {
	-- ['Governor'] = 1154604027514978465,
	-- ['Deputy Governor'] = 1154604015636729900,
	-- ['Divisional Commander'] = 1154603972406034452,
	-- ['Custodial Supervisor'] = 1154603978454208543,
	-- ['Custodial Officer'] = 1154603963560235149,
	-- ['Honourable Guard'] = 1154604000826642522,
	-- ['Supervising Officer'] = 1154604030279045151,
	-- ['Principal Officer'] = 1154603960116719627,
	-- ['Specialist Officer'] = 1154604001615163423,
	-- ['Senior Officer'] = 1154603997605400638,
	-- ['Prison Officer'] = 1154603950520156211,
	-- ['Trainee Prison Officer'] = 1154603959684694036,
	-- -- },

	-- ['LFB'] = {
	-- 	['Chief Fire Command'] = 1008206875923324988,
	-- 	['Divisional Command'] = 1008206879731757157,
	-- 	['Sector Command'] = 1008206880738390016,
	-- 	['Honourable Firefighter'] = 1008206885251469353,
	-- 	['Leading Firefighter'] = 1008206886002237571,
	-- 	['Specialist Firefighter'] = 1008206886761418762,
	-- 	['Advanced Firefighter'] = 1008206887558324246,
	-- 	['Senior Firefighter'] = 1008206888778862733,
	-- 	['Firefighter'] = 1008206889768730695,
	-- 	['Junior Firefighter'] = 1008206890775359590,
	-- 	['Provisional Firefighter'] = 1008206891157028927,	
	-- },	
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end


cfg.Bot_Token = 'MTE2MjM5NTA4NzAzMzA5MDE3OA.GxLUfJ.lwFPXUhh2jb-inR1ezj8R-viTnfHgDQKRIuGTs'

return cfg