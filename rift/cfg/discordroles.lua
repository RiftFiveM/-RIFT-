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

	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 1162343507780964399, -- 12
		['Lead Developer'] = 1165759097707167844, -- 11
		['Developer'] = 1165759271405883392, -- 10
		['Community Manager'] = 1165750931850268702, -- 9
		['Operations Manager'] = 1166536270839820342, -- 8
		['Staff Manager'] = 1165751122523340850, -- 8
		['Head Administrator'] = 1165751337942782053, -- 7
		['Senior Administrator'] = 1165751640788316260, -- 6
		['Administrator'] = 1165751811685236907, -- 5
		['Senior Moderator'] = 1165751962751488050, -- 4
		['Moderator'] = 1165752126685847622, -- 3
		['Support Team'] = 1165752306864771132, -- 2
		['Trial Staff'] = 1165752415522398339, -- 1
		['cardev'] = 1165761064814784582,
		['Cinematic'] = 1165762157175128168,
		['Supporter'] = 1165762084747886672,
		['Premium'] = 1165762013805416458,
		['Supreme'] = 1165761947904516156,
		['Kingpin'] = 1165761887263268874,
		['Rainmaker'] = 1165761822398353599,
		['Baller'] = 1165761779075387626,
		['Booster'] = 1162482745499471883,
	},

	['Police'] = {
        ['Commissioner'] = 1165781104008110121,
        ['Deputy Commissioner'] = 1165781105035706479,
        ['Assistant Commissioner'] = 1165781105899753595,
        ['Dep. Asst. Commissioner'] = 1165781106734411826,
        ['Commander'] = 1165781107636191243,
        ['Chief Superintendent'] = 1165781118390382663,
        ['Superintendent'] = 1165781119837421670,
        ['Chief Inspector'] = 1165781130520301599,
        ['Inspector'] = 1165781131803770920,
        ['Sergeant'] = 1165781133733134417,
        ['Special Constable'] = 1165781142289518752,
        ['Senior Constable'] = 1165781135528300554,
        ['PC'] = 1166564106346709033,
        ['PCSO'] = 1165781140280451184,
        ['Large Arms Access'] = 1165781229585571941,
        ['Police Horse Trained'] = 1166564332360962148,
        ['Drone Trained'] = 1165781245217751121,
        ['NPAS'] = 1165781215564025937,
        ['Trident Officer'] = 1166564604659384381,
        ['Trident Command'] = 1166564700172079114,
        ['K9 Trained'] = 1165781259834904607,
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

cfg.Bot_Token = 'MTE2MzU4NDU4NzU2MjI0MjE3OA.Gp2wFX.Rohi2yETMiEK57AcV7mJHJ2_YpYLlK0PDQvm9M'

return cfg
