--[[
	NAME -			User Management
	AUTHOR -		Roy (Christian Deacon)
	DESCRIPTION -	Gives GFL members their correct rank.
	DATE -			August 20th, 2016
]]--

-- Plugin details.
PLUGIN.Title = "User Management"
PLUGIN.Author = "Roy (Christian Deacon)"
PLUGIN.Version = V(0, 1, 0)
PLUGIN.Description = "Gives GFL members their correct rank."

-- Global Variables
local db = false

-- Function: OnServerInitialized
function PLUGIN:OnServerInitialized()
	db = mysql.OpenDb("dbHost", 3306, "dbName", "dbUser", "dbPass", self.Plugin, false)
end

-- Function: OnPlayerInit
function PLUGIN:OnPlayerInit(player)
	if db then
		
		local steamid = rust.UserIDFromPlayer(player)
		print("[UM]Doing SQL stuff. (Steam ID: " .. steamid .. ")")
		local sql = mysql.NewSql():Select("groupid"):From("sb_perks"):Where("steamid='" .. steamid .. "'")
		
		mysql.Query(sql, db, function (data)
			if data == nil then return end
			
			for i=0, data.Count-1 do
				local itData = data[i]:GetEnumerator()
				
				while itData:MoveNext() do
					-- Get the group ID.
					local groupid = itData.Current.Value
					local sGroup = "default"
					-- Add the user to the group!
					local user = player.displayName
					
					if groupid == 1 then
						-- Member
						sGroup = "member"
						
						-- Remove other groups.
						rust.RunServerCommand("usergroup remove \"" .. user .. "\" \"supporter\"")
						rust.RunServerCommand("usergroup remove \"" .. user .. "\" \"vip\"")
					elseif groupid == 2 then
						-- Supporter
						sGroup = "supporter"
						
						-- Remove other groups.
						rust.RunServerCommand("usergroup remove \"" .. user .. "\" \"member\"")
						rust.RunServerCommand("usergroup remove \"" .. user .. "\" \"vip\"")
					elseif groupid == 3 then
						-- VIP
						sGroup = "vip"
						
						-- Remove other groups.
						rust.RunServerCommand("usergroup remove \"" .. user .. "\" \"member\"")
						rust.RunServerCommand("usergroup remove \"" .. user .. "\" \"supporter\"")
					else
						print("[UM]User has a bad groupid value (" .. steamid .. ")")
						return
					end
					
					if not permission.UserHasGroup(steamid, sGroup) then
						rust.RunServerCommand("usergroup add \"" .. user .. "\" \"" .. sGroup .. "\"")
						
						print("Added '" .. steamid .. "' (" .. user .. ") to group '" .. sGroup .. "'!")
					else
						print("User '" .. steamid .. "' (" .. user .. ") already in group '" .. sGroup .. "'!")
					end
				end
			end
		end)
	else
		print("[UM] Error connecting to database.")
	end
end

-- Function: Unload
function PLUGIN:Unload()
	mysql.CloseDb(db)
end