
local TEXT_FONT = Enum.Font.Code
local TEXT_SIZE = 14
-- main frame config
local MAIN_COLOR = Color3.fromRGB(35, 35, 35)
local MAIN_BCOLOR = Color3.fromRGB(77, 77, 77)
local MAIN_SIZE = UDim2.fromOffset(500, 500)
local MAIN_TEXT_COLOR = Color3.fromRGB(203, 203, 203)
local MAIN_TEXT_ALIGN_X = Enum.TextXAlignment.Left
local MAIN_TEXT_ALIGN_Y = Enum.TextYAlignment.Top
-- header frame config
local HEADER_COLOR = Color3.fromRGB(54, 54, 54)
local HEADER_TEXT_COLOR = Color3.fromRGB(206, 206, 206)
local HEADER_HEIGHT = 20
local HEADER_TEXT_ALIGN_X = Enum.TextXAlignment.Left

-- output frame config
local OUTPUT_SCROLLBAR_WIDTH = 10

local function newInstance(className, name, parent, propertyList)
	local i = Instance.new(className)
	i.Name = name
	i.Parent = parent
	for prop, value in pairs(propertyList) do
		local succ, err = pcall(function()  -- bruh lmao
			i[prop] = value
		end)
		if not succ then
			warn("New Instance: Error Setting Property[" .. prop .. "]: " .. err)
		end
	end
	return i
end

local function createConsoleFrame()
	-- create console frame
	local consoleFrame = newInstance("Frame", "Console", nil, {
		BackgroundColor3 = MAIN_COLOR,
		BorderColor3 = MAIN_BCOLOR,
		BorderSizePixel = 4,
		Size = MAIN_SIZE
	})
	
	-- top header
	local headerFrame = newInstance("Frame", "Header", consoleFrame, {
		BackgroundColor3 = HEADER_COLOR,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
	})
	
	-- title in top header
	local headerTitle = newInstance("TextLabel", "ConsoleTitle", headerFrame, {
		BackgroundTransparency = 1,
		Text = "Console",
		TextSize = TEXT_SIZE,
		TextColor3 = HEADER_TEXT_COLOR,
		TextXAlignment = HEADER_TEXT_ALIGN_X,
		Font = TEXT_FONT,
		Size = UDim2.new(1, -5, 1, 0),
	})
	
	-- input frame
	local inputFrame = newInstance("Frame", "InputFrame", consoleFrame, {
		BackgroundColor3 = HEADER_COLOR,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1)
	})
	
	-- input box in input frame
	local inputBox = newInstance("TextBox", "InputBox", inputFrame, {
		BackgroundTransparency = 1,
		PlaceholderText = "Enter Input",
		Text = "",
		TextSize = TEXT_SIZE,
		TextColor3 = HEADER_TEXT_COLOR,
		TextXAlignment = HEADER_TEXT_ALIGN_X,
		Font = TEXT_FONT,
		Size = UDim2.new(1, -5, 1, 0),
	})
	
	-- output frame
	local outputFrame = newInstance("ScrollingFrame", "OutputFrame", consoleFrame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -2 * HEADER_HEIGHT),
		Position = UDim2.new(0, 0, 0, HEADER_HEIGHT),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = OUTPUT_SCROLLBAR_WIDTH,
	})
	
	return consoleFrame
end

local console 
do
	local textService = game:GetService("TextService")
	local outputTextPrefab = newInstance("TextLabel", "OutputText", script, {
		BackgroundTransparency = 1,
		Text = "",
		TextSize = TEXT_SIZE,
        TextWrapped = true,
        TextXAlignment = MAIN_TEXT_ALIGN_X,
        TextYAlignment = MAIN_TEXT_ALIGN_Y,
		Font = TEXT_FONT,
		Position = UDim2.new(0, 5, 0, 0),
		Size = UDim2.new(1, 0, 0, 14),
	})

	console = {}
	console.__index = console

	function console.new(guiParent)
		local self = setmetatable({}, console)
        -- console variable
        self.frame = createConsoleFrame()--script.Parent.Console-- for now
        syn.protect_gui(self.frame)
		self.frame.Parent = guiParent
		self.currInputCallback = nil
		self.inputCallbacks = {}
		self.outputLabels = {}
		-- state variables
		self.inputting = false
		-- text style variables
		self.textSize = 14
		self.textColor = Color3.fromRGB(203, 203, 203)
		-- handle iniating
		self.frame.InputFrame.InputBox.Text = ""
		self.frame.InputFrame.InputBox.ClearTextOnFocus = false
		self.frame.InputFrame.InputBox.Visible = false
		self.frame.InputFrame.InputBox.FocusLost:Connect(function(...) 
			if self.inputting then
				self:_endinput(...)
			end
		end)
		return self
    end
    
    function console.test()
        local player = game:GetService("Players").LocalPlayer
        local coreGui = game:GetService("CoreGui")
        local sGui = Instance.new("ScreenGui", coreGui)
        sGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local c = console.new(sGui)
        c:setTitle("A Title")
        c:setSize(UDim2.fromOffset(300, 300))
        c:setPosition(UDim2.fromScale(0.5, 0.5))
        c:setAnchorPoint(Vector2.new(0.5, 0.5))
        task.spawn(function() 
            wait(0.5) 
            print(c:getFrame().Parent) 
        end)
        c:getFrame().ZIndex = 1000
        while true do
            task.wait() -- just in case
            c:input()
        end
    end

	-- private functionality
	local function getLast(labels)
		return labels[#labels]
	end

	-- input
	function console:_endinput(enterPressed)
		if enterPressed then
			self.inputting = false
			local inputbox = self.frame.InputFrame.InputBox
			local input = self.frame.InputFrame.InputBox.Text
			-- clear/reset textbox
			inputbox.Visible = false
			inputbox.Text = ""
			inputbox.Active = false
			-- do callback
			self:print(string.format("> %s", input))
			if self.currInputCallback then
				self.currInputCallback(input)
			end
			-- check for any requests in the callback queue
			if self.inputCallbacks[1] then
				local t = table.remove(self.inputCallbacks, 1)
				self:_startinput(t[1], t[2])
			end
		end
	end

	function console:_startinput(callback, prompt)
		if self.inputting then
			table.insert(self.inputCallbacks, {callback, prompt})
			return
		end
		self.currInputCallback = callback
		if prompt then
			self:print(prompt)
		end
        local inputbox = self.frame.InputFrame.InputBox
        inputbox.Text = ""
		inputbox.Visible = true
		inputbox.Active = true
		self.inputting = true
		--inputbox:CaptureFocus()
	end
	
	function console:input(prompt) -- async
		local b = Instance.new("BindableEvent")
		self:_startinput(function(input) 
				b:Fire(input)
			end, 
			prompt)
		return b.Event:Wait()
	end

	function console:inputCallback(callback, prompt)
		self:_startinput(callback, prompt)
    end
    
	--- printing
	function console:_print(s, c)
		local outputFrame = self.frame.OutputFrame
		local textLabel = outputTextPrefab:Clone()
		textLabel.Text = s
		textLabel.TextColor3 = c
		textLabel.TextSize = self.textSize
		-- get size
		local size = textService:GetTextSize(s, self.textSize, textLabel.Font, Vector2.new(self.frame.AbsoluteSize.X - self.frame.OutputFrame.ScrollBarThickness, math.huge))
		textLabel.Size = UDim2.fromOffset(size.X, size.Y)
		-- get position
		local last = getLast(self.outputLabels)
		local pos = UDim2.fromOffset(5, last and (last.Position.Y.Offset + last.AbsoluteSize.Y) or 0)
		textLabel.Position = pos
		-- parent and record
		textLabel.Parent = self.frame.OutputFrame
		--outputFrame.CanvasSize = UDim2.new(0, 0, 0, textLabel.AbsolutePosition.Y - outputFrame.AbsolutePosition.Y + textLabel.AbsoluteSize.Y)
		outputFrame.CanvasPosition = Vector2.new(0, outputFrame.AbsoluteCanvasSize.Y - outputFrame.AbsoluteWindowSize.Y)
		--outputFrame.
		table.insert(self.outputLabels, textLabel)
	end

	function console:print(s)
		self:_print(s, self.textColor)
	end

	function console:printColor(s, color)
		self:_print(s, color)
    end
    
    function console:clear()
        for _, v in ipairs(self.outputLabels) do
            v:Destroy()
        end
        self.outputLabels = {}
    end
	-- gui state stuff
	function console:focus()
		self.frame.InputFrame.InputBox:CaptureFocus()
	end

	function console:releaseFocus()
		self.frame.InputFrame.InputBox:ReleaseFocus()
	end

	function console:toggleFocus()
		local inputBox = self.frame.InputFrame.InputBox
		if inputBox:IsFocused() then
			inputBox:ReleaseFocus()
		else
			inputBox:CaptureFocus()
		end
	end
	
	function console:setVisible(b)
		b = (b == nil) and true or b -- b defaults to true if no input
		self.frame.Visible = b
	end

	function console:toggleVisible()
		self.frame.Visible = not self.frame.Visible
	end

	-- gui editing
	function console:setTitle(title)
		self.frame.Header.ConsoleTitle.Text = title
	end

	function console:setAnchorPoint(p)
		self.frame.AnchorPoint = p
	end

	function console:setPosition(positionUDim)
		self.frame.Position = positionUDim
	end

	function console:setSize(sizeUDim)
		self.frame.Size = sizeUDim
	end

	function console:setTextSize(textSize)
		--self.textSize = 14
	end

	function console:getFrame() -- for further customization
		return self.frame
    end
    
    function console:destroy()
        self.frame:Destroy() -- i think this is all needed for now
    end
end

return console