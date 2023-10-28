cfg = {
	Guild_ID = '1167224647142621236',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '1167224647142621236', 
		['Police'] = '1167257790859989012', 
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
		['Founder'] = 1167232119089672252, -- 12
		['Lead Developer'] = 1167234402699448391, -- 11
		['Developer'] = 1167234611353505802, -- 10
		['Community Manager'] = 1167232564759638027, -- 9
		['Operations Manager'] = 1167235083493707968, -- 8
		['Staff Manager'] = 1167235384980291695, -- 8
		['Head Administrator'] = 1167235631613759640, -- 7
		['Senior Administrator'] = 1167235895246729237, -- 6
		['Administrator'] = 1167236379869192212, -- 5
		['Senior Moderator'] = 1167236663991337000, -- 4
		['Moderator'] = 1167237033647939584, -- 3
		['Support Team'] = 1167237195610980434, -- 2
		['Trial Staff'] = 1167233295113801840, -- 1
		['cardev'] = 1167232741578899486,
		['Cinematic'] = 1167269573922390056,
		['Supporter'] = 1167238554603233350,
		['Premium'] = 1167232848395247727,
		['Supreme'] = 1167238630910210098,
		['Kingpin'] = 1167238779791233115,
		['Rainmaker'] = 1167238900658470984,
		['Baller'] = 1167232902539518013,
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

cfg.Bot_Token = 'MTE2MzU4NDU4NzU2MjI0MjE3OA.GOYWiu.sGWCVBXOWzwy-ZDOemTgim0dwRASFXG5XD5tQU'

return cfg