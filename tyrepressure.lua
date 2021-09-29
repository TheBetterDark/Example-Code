-- Variables
local RunService = game:GetService("RunService")
local car = script.Parent.Parent.Car.Value
local _Tune = require(car["Tuner"])

--local handler = car.TirePressure

local fWheel = car.FrontSection
local rWheel = car.RearSection

-- Settings
local _Settings = {	
	FP = 70; -- Higher less pressure 
	RP = 70; -- Higher less pressure 
	LOAD = 0.9; -- At what suspension load the pressure reduces , find what suits you --- up to 0.99
}

-- Stores wheel size for later use
script.WS1.Value = fWheel.F.Size
script.WS2.Value = rWheel.R.Size

-- Loop
RunService.Heartbeat:Connect(function()
	local S1 =  (fWheel.FrontSuspensionBase.SpringConstraint.CurrentLength)
	local S2 =  (car.Body.RearSuspensionBase.SpringConstraint.CurrentLength)
	
	-- Simulates the tire pressure by reducing/increasing the wheel size
	if S1 > _Settings.LOAD -0.001   then 
		fWheel.F.Size = script.WS1.Value*(0.999999+S1)/(_Settings.FP/10)*2
		--handler:FireServer("S1",script.WS1.Value,0.999999,S1,_Settings.FP)
	else
		fWheel.F.Size = script.WS1.Value*(0.999998+S1)/(_Settings.FP/10)*2
		--handler:FireServer("S1",script.WS1.Value,0.999998,S1,_Settings.FP)
	end

	if S2 > _Settings.LOAD  -0.001  then
		rWheel.R.Size = script.WS2.Value*(0.999999+S1)/(_Settings.RP/10)*2
		--handler:FireServer("S2",script.WS2.Value,0.999999,S2,_Settings.RP)
	else
		rWheel.R.Size = script.WS2.Value*(0.999998+S1)/(_Settings.RP/10)*2
		--handler:FireServer("S2",script.WS2.Value,0.999998,S2,_Settings.RP)
	end	
	
	-- Restores orginal wheel size
	car.DriveSeat.ChildRemoved:connect(function(child)
		fWheel.F.Size = script.WS1.Value
		rWheel.R.Size = script.WS2.Value
	end)
end)
