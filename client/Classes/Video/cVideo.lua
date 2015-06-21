--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
CVideo = {}

function CVideo:constructor(Name, FrameCount, FPS)
	self.Name = Name
	self.FrameCount = FrameCount
	
	self.CurrentFrame = 1
	self.LastFrame = 0
	
	self.FPS = FPS
	
	self.Frame = 0
	self.Frames = {}
	
	self.State = false
	
	self.RenderTarget = dxCreateRenderTarget(640, 420)
	
	self.Shader = dxCreateShader("res/shader/video.fx")
	engineApplyShaderToWorldTexture(self.Shader, "drvin_screen")
	
	self.Imagepath = "http://178.254.22.55/iLife/Videos/"
	self.Soundpath = "http://178.254.22.55/iLife/Videos/"..self.Name.."/music.mp3"
	
	self.tTimer = bind(CVideo.Timer, self)
	self.PlayTimer = false
	
	self.SoundBuffered = false
	
	self.cbBufferCallback = bind(CVideo.bufferCallback, self)
	
	for i=1,self.FrameCount,1 do
		if fileExists("/Videos/"..self.Name.."/"..i..".jpg") then
			local file = fileOpen("/Videos/"..self.Name.."/"..i..".jpg")
			self.Frames[i] = fileRead(file, fileGetSize(file))
			fileClose(file)
			----outputChatBox("Loaded Frame: "..i)
		else
		end
	end
end

function CVideo:start()
	self:startBuffer()
	setTimer(
		function()
			self.Starttick = getTickCount()
			self.Endtick = self.Starttick+((1000/self.FPS)*self.FrameCount)
			self.Length =  self.Endtick - self.Starttick
			addEventHandler("onClientRender", getRootElement(), self.tTimer)
			self.State = true
		end
	, 5000, 1)
end

function CVideo:stop()
	if(isTimer(self.PlayTimer)) then
		killTimer(self.PlayTimer)
	end
	self.State = false
	stopSound(self.Sound)
	removeEventHandler("onClientRender", getRootElement(), self.tTimer)
end

function CVideo:startBuffer()
	if not (fileExists("/Videos/"..self.Name.."/music.mp3")) then
		if  not (self.SoundBuffered) then
			--outputChatBox("fetching Sound...")
			fetchRemote(self.Imagepath..self.Name.."/"..self.Name..".revid.1", 
			function(bytes)
				self.SoundBuffered = true
				local file = fileCreate("/Videos/"..self.Name.."/tmp.01")
				fileWrite(file, bytes)
				fileSetPos(file, 0)
				
				fileSetPos(file, 76)
				local soundbytes = fileRead(file, 16)
				fileSetPos(file, 93)
				local sound = fileCreate("/Videos/"..self.Name.."/music.mp3")
				fileWrite(sound, fileRead(file, soundbytes))
				fileClose(sound)
				fileClose(file)
				fileDelete("/Videos/"..self.Name.."/tmp.01")
			end
			)
		end
	end
	if  not(self.State) and (#self.Frames == 0) then
		self:buffer()
	else
	
	end
end

function CVideo:buffer()

	if (#self.Frames >= self.FrameCount) then
		self:dump()
		return true
	end
	self.curFrame = #self.Frames+1
	--outputChatBox("fetching..."..self:round(((#self.Frames+1)/100)+2))
	fetchRemote(self.Imagepath..self.Name.."/"..self.Name..".revid."..self:round(((#self.Frames+1)/100)+2), self.cbBufferCallback, "", false, self:round(((#self.Frames+1)/100)+2) )
end

function CVideo:round(number, decimals, method)
	 decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function CVideo:bufferCallback( jpgs, errno, ct)
	--outputChatBox("Frame Callback.."..errno)
	local file = fileCreate("/tmp/tmp.revid")
	fileWrite(file, jpgs)
	fileSetPos(file, 0)
	while (not fileIsEOF(file) ) do 
		local posbefore = fileGetPos(file)
		local framebytes = tonumber(fileRead(file, 8))
		if framebytes then
		fileSetPos(file, posbefore+9)
			local pixels = fileRead(file, framebytes)
			fileSetPos(file, posbefore+9+framebytes)
			table.insert(self.Frames, pixels)
			local img = fileCreate("/Videos/"..self.Name.."/"..#self.Frames..".jpg")
			fileWrite(img, pixels)
			fileClose(img)
		end
	end
	fileClose(file)
	
	fileDelete("/tmp/tmp.revid")
	
	--outputChatBox("Frame: "..#self.Frames.."/"..self.FrameCount)
	self:buffer()
end

lasttick = getTickCount()

lastRenderedFrame = 0

function CVideo:Timer()
	local tick = math.round(self.Length / self.FrameCount)
	local curtick = getTickCount() - self.Starttick
	local frame = math.round(curtick / tick)

	if (self.Frame == 1) then
		if not (isElement(self.Sound)) then
			if (fileExists("/Videos/"..self.Name.."/music.mp3")) then
				self.Sound = playSound("/Videos/"..self.Name.."/music.mp3")
			else
				--Sound has to be buffered!
				self.Starttick = getTickCount()
				return true
			end
		end
	end
	self.Frame = frame
	if (self.Frame >= self.FrameCount) then
		self:stop()
		return true
	end
	if not(self.Frame > #self.Frames) then
		if (#self.Frames < self.Frame) then
		 -- Wait until Frame was buffered, pause Sound
		 setSoundPaused (self.Sound, true)
		else
			--if (lastRenderedFrame < frame) then
				-- Methode 1 : RenderTarget (High Ram-Usage, because of texturecaching)
				
				dxSetRenderTarget(self.RenderTarget, true)	
				local tex = dxCreateTexture("/Videos/"..self.Name.."/"..frame..".jpg", "argb", false, "wrap")
				--Time Label
				--dxDrawMaterialLine3D ( 0, 0, 0, 5, 0, 0, , 6)
				dxDrawImage(0,20,640,360,tex)
				dxDrawText(math.round((frame/self.FPS)/60)..":"..addZero(math.round((frame/self.FPS)%60)).."/"..math.round((self.FrameCount/self.FPS)/60)..":"..addZero(math.round((self.FrameCount/self.FPS)%60)), 1, 1, 1, 1, tocolor(130,130,130), 1, "pricedown", "left", "top", false, false, false, false, false)
				dxDrawText(self.Name..".revid", 1, 1, 640, 20, tocolor(130,130,130), 1, "pricedown", "right", "top", false, false, false, false, false)

				--dxDrawText(
				--Buffering Line
				dxDrawLine(0,385,640,385,tocolor(20,20,20),20)
				--Buffered Line
				dxDrawLine(0,385,640*(#self.Frames/self.FrameCount),385,tocolor(100,100,100),20)
				--Played Line
				dxDrawLine(0,385,640*(frame/self.FrameCount),385,tocolor(200,0,0),20)
				--Button
				dxDrawRectangle(640*(frame/self.FrameCount)-12,373,24,24, tocolor(150,150,150))
				dxDrawRectangle (640*(frame/self.FrameCount)-7,378,14,14, tocolor(210,210,210))
				dxSetRenderTarget()
				dxSetShaderValue(self.Shader, "gTexture", self.RenderTarget)
				--dxDrawImage(0,0,640,420, self.RenderTarget)
				--dxDrawImage(
				--dxDrawMaterialLine3D(0, 0, 0, *8.53333, 0, 0, *4.26666)
				destroyElement(tex)
				-- Methode 2 : dxCreateTexture() // Slower?
				--local tex = dxCreateTexture("/Videos/"..self.Name.."/"..frame..".jpg", "argb", false, "wrap")
				--dxSetShaderValue(self.Shader, "gTexture", tex)
				-- Clear the Texture. //Ram-Usage
				--destroyElement(tex)
			--end
			
			lastRenderedFrame = frame
			if (self.Sound) then
				if (isSoundPaused(self.Sound)) then
					setSoundPaused (self.Sound, false)
				end
			end
		end
	else
		--self:stop()
	end
	lasttick = curtick
end

function CVideo:destructor()

end

function CVideo:dump()
	local file = fileCreate("/"..self.Name..".revid")
	fileWrite(file, tostring(self.FrameCount))
	fileSetPos(file, 9)
	fileWrite(file, self.Name)
	fileSetPos(file, 76)
	local sound = fileOpen("/Videos/"..self.Name.."/music.mp3")
	fileWrite(file, tostring(fileGetSize(sound)))
	fileSetPos(file, 93)
	fileWrite(file, fileRead(sound, fileGetSize(sound)))
	fileClose(sound)
	local file2 = fileCreate("/tmp/"..self.Name..".revid.1")
	fileSetPos(file, 0)
	fileWrite(file2, fileRead(file,fileGetSize(file)))
	fileClose(file2)
	local tmpfile = false
	for k,v in ipairs(self.Frames) do
		--outputDebugString(k.."|"..k%100)
		if (k%100 == 1) then
			if (tmpfile) then 
				fileClose(tmpfile)
			end
			tmpfile = fileCreate("/tmp/"..self.Name..".revid."..math.round((k/100)+2))
		end
		local bytes = string.len(v)
		local pos = fileGetPos(file)
		local posbefore = fileGetPos(file)
		fileWrite(file, tostring(bytes))
		fileSetPos(file, posbefore+9)
		fileWrite(file, v)
		
		local pos = fileGetPos(tmpfile)
		local posbefore = fileGetPos(tmpfile)
		fileWrite(tmpfile, tostring(bytes))
		fileSetPos(tmpfile, posbefore+9)
		fileWrite(tmpfile, v)
	end
	fileClose(file)
	fileClose(tmpfile)
	--outputChatBox("File saved succesfully!")
end

function CVideo:read()
	if (fileExists("/"..self.Name..".revid")) then
		local file = fileOpen("/"..self.Name..".revid")
		local framecount = tonumber(fileRead(file, 8))
		--outputChatBox("Frames: "..framecount)
		fileSetPos(file, 9)
		local name = fileRead(file, 64)
		--outputChatBox("Name: "..name)
		fileSetPos(file, 76)
		local soundbytes = fileRead(file, 16)
		--outputChatBox("Soundbytes: "..soundbytes)
		fileSetPos(file, 93)
		local sound = fileCreate("/Videos/"..self.Name.."/music.mp3")
		fileWrite(sound, fileRead(file, soundbytes))
		--outputChatBox("Sound created!")
		fileClose(sound)
		--outputChatBox(fileGetPos(file).." == "..soundbytes+93)
		for k=1, framecount, 1 do
			local posbefore = fileGetPos(file)
			local framebytes = fileRead(file, 8)
			fileSetPos(file, posbefore+9)
			--outputChatBox("Framebytes ("..k.."): "..framebytes)
			local img = fileCreate("/Videos/"..self.Name.."/"..k..".jpg")
			fileWrite(img, fileRead(file, framebytes))
			fileClose(img)
		end
		fileClose(file)
	else
		--outputChatBox("File was not found!")
	end
end

addEventHandler("onClientResourceStart", getRootElement(), 
	function(startedResource)
		if (startedResource == getThisResource()) then
			Leinwand = createObject(16000, 1524.09998, -1756.09998, 17.5, 0, 0, 0, false)
			--VioDiss = enew(Leinwand, CVideo, "Vio-Trailer", 3469, 30)
			Video = enew(Leinwand, CVideo, "I just Had Sex", 3506, 20)
			--VioDiss = enew(Leinwand, CVideo, "Ants", 1298, 15)
		end
	end
)

addCommandHandler("dump",
function(player)
	VioDiss:dump()
end
)


addEventHandler("onClientClick", getRootElement(),
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
		if (clickedWorld == Video) then
			if (not Video.State) then
				Video:start()
			else
				Video:stop()
			end
		end
	end
)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function addZero(value)
	if (value < 10) then
		return "0"..value
	else
		return value
	end
end
setHeatHaze ( 0)
]]