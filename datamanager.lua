-- Variables
local Players = game:GetService("Players")
local ProfileService = require(script.ProfileService)
local ProfileStore = ProfileService.GetProfileStore(
	"SaveData",
	{
		GameStats = {
			-- Game Stats
			Cash = 10000; -- Default Cash
			Level = 0; -- Default Level
			XP = 0; -- XP Requirment = Level*1000
			RaceMode = {
				SR = 0; -- Race Mode Rider Rating
			};
		};

		PersonalBestLapTimes = {
		--[[TrackName = {
				BestLap = nil;
				Sectors = {
					S1 = nil;
					S2 = nil;
					S3 = nil;
					S4 = nil; 
				};
			}]]

			Monza = {
				BestLap = 0;
				Sectors = {
					S1 = 0;
					S2 = 0;
					S3 = 0;
					S4 = 0;
				};
			};
		};

		BikesOwned = {
		-- If empty means they own no bikes
--[[		BikeName = {
				Customisation = {
					(Will be expanded)
				}
			}
]]
		};
		
		Settings = {
			Audio = {
				MenuMusic = true;
			};
			Controls = {
				Keyboard = {};
				Mouse = {};
				Controller = {};
			};
			Graphics = {
				Bloom = true;
				DepthOfField = true;
				ScreenRain = true;
				SunRays = true;
			};
			HUD = {
				LengthUnit = "MPH";
				TimingIndicator = true;
				Map = true;
			};
		};
	}
)

local Profiles = {}

-- Inputing player data after being loaded
local function PlayerDataLoaded(player)
	local profile = Profiles[player]
	local GUI = player.PlayerGui:WaitForChild("IntroGUIV1")

	local Cash = GUI.MainMenu.Money.Cash
	Cash.Text = "$ " .. profile.Data.GameStats.Cash

	local Level = GUI.MainMenu.Level.Level
	Level.Text = profile.Data.GameStats.Level
	
	local Settings = player.PlayerGui.Configuration.Settings
	
	Settings.Audio.MenuMusic.Value = profile.Data.Settings.Audio.MenuMusic
	
	Settings.Hud.Map.Value = profile.Data.Settings.HUD.Map
	Settings.Hud.TimingIndicator.Value = profile.Data.Settings.HUD.TimingIndicator
	Settings.Hud.LengthUnit.Value = profile.Data.Settings.HUD.LengthUnit
	
	Settings.Graphics.Bloom.Value = profile.Data.Settings.Graphics.Bloom
	Settings.Graphics.DepthOfField.Value = profile.Data.Settings.Graphics.DepthOfField
	Settings.Graphics.ScreenRain.Value = profile.Data.Settings.Graphics.ScreenRain
	Settings.Graphics.SunRays.Value = profile.Data.Settings.Graphics.SunRays
	
  -- Updating player cash & level to UI
	spawn(function()
		while true do
			wait(0.1)
			if profile ~= nil then
				Cash.Text = "$ " .. profile.Data.GameStats.Cash
				Level.Text = profile.Data.GameStats.Level
			else
				break
			end
		end
	end)

	print(player.Name .. "'s data has been loaded.")
end

-- Loads player data after joining server
local function onPlayerAdded(player)
	local profile = ProfileStore:LoadProfileAsync(
		"Player_" .. player.UserId,
		"ForceLoad"
	)
  
  -- Adds values missing from player data
	profile:Reconcile()

	if profile then
		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(Players) then
			Profiles[player] = profile
			PlayerDataLoaded(player)
		else
			profile:Release()
		end
	else	
		player:Kick("Unable to load saved data. Please Rejoin!")
	end

end

local function onPlayerRemoving(player)
	local profile = Profiles[player]

	if profile then
		profile:Release()
	end
end

-- In case Players have joined the server earlier than this script ran:
for _, player in ipairs(Players:GetPlayers()) do
	coroutine.wrap(onPlayerAdded)(player)
end


Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

local DataManager = {}

function DataManager:Get(player)
	local profile = Profiles[player]

	if Profiles[player] then
		return profile.Data
	end

end

return DataManager