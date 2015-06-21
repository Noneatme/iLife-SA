--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CExplorePoint = {}

function CExplorePoint:constructor(AchievementID)
	self.AchievementID = AchievementID
	
	self.eOnHit = bind(CExplorePoint.onHit, self)
	addEventHandler("onColShapeHit", self, self.eOnHit)
end

function CExplorePoint:destructor()

end

function CExplorePoint:onHit(hitElement, matchingGimension)
	if (getElementType(hitElement) == "player") then
		Achievements[self.AchievementID]:playerAchieved(hitElement)
	end
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
	function()
		--Mt. Chillard
		enew(createColSphere( -2234.3190917969, -1740.4943847656, 480.83181762695, 10), CExplorePoint, 73)
		--SF Trainstation
		enew(createColSphere( -1980.0837402344, 138.00666809082, 27.6875, 25), CExplorePoint, 85)
		--Bayside
		enew(createColSphere(-2466.1997070313, 2340.1176757813, 4.835937, 250), CExplorePoint, 84)
		--Strip Clubs
		enew(createColSphere( -2639.6625976563, 1406.5084228516, 906.4609375, 25), CExplorePoint, 66)
		enew(createColSphere( 1210.6784667969, -33.123733520508, 1000.9605712891, 12), CExplorePoint, 66)
		--Clubs
		enew(createColSphere(489.92501831055, -12.91512298584, 1000.6796875, 25), CExplorePoint, 71)
		--Gyms
		enew(createColSphere(765.66638183594, 8.1768646240234, 1000.7130737305, 20), CExplorePoint, 72)
	end
)