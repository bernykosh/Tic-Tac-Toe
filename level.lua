----------------------------------------
-- SCENE  : LEVEL SELECTING SCREEN               
----------------------------------------
local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local backGroup = display.newGroup()    --Group for the background image
local uiGroup = display.newGroup()      --Group for any buttons

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoEasy(event)
    if( "ended" == event.phase ) then
        level = 1   --Set level variable to 1 for Easy
        composer.setVariable("levelNow", level)   --Pass the level variable as "levelNow" 
	    composer.gotoScene("game", { time=800, effect="fromRight" })    --Goes to the Game Scene
    end
end

local function gotoMedium(event)
    if( "ended" == event.phase ) then
        level = 2   --Set level variable to 2 for Medium
        composer.setVariable("levelNow", level)
	    composer.gotoScene("game", { time=800, effect="fromRight" })
    end
end

local function gotoHard(event)
    if( "ended" == event.phase ) then
        level = 3   --Set level variable to 3 for Hard
        composer.setVariable("levelNow", level)
	    composer.gotoScene("game", { time=800, effect="fromRight" })
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

	sceneGroup:insert(backGroup) 
	sceneGroup:insert(uiGroup)

--- Background image
	local background = display.newImageRect( backGroup, "background.png", 400, 800 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

--- Create Easy button
	local easyButton = widget.newButton(
        {
            label = "EASY", fontSize=30, font="Arial Black",
            labelColor = {default={ 1, 1, 1 }, over={ 1, 1, 1 }}, 
            onEvent = gotoEasy,
            shape = "roundedRect",
            width = 170,
            height = 40,
            cornerRadius = 2,
            fillColor = {default={1,0.4,0.5}, over={0,0,0}},
            strokeColor = {default={0.9,0,0.4}, over={0,0,0}},
            strokeWidth = 4
        }
    )
    easyButton.x = display.contentCenterX
    easyButton.y = display.contentCenterY-100
    uiGroup:insert(easyButton)  --Inserts button to uiGroup

--- Create Medium button
    local mediumButton = widget.newButton(
        {
            label = "MEDIUM", fontSize=30, font="Arial Black",
            labelColor = {default={ 1, 1, 1 }, over={ 1, 1, 1 }}, 
            onEvent = gotoMedium,
            shape = "roundedRect",
            width = 170,
            height = 40,
            cornerRadius = 2,
            fillColor = {default={1,0.4,0.5}, over={0,0,0}},
            strokeColor = {default={0.9,0,0.4}, over={0,0,0}},
            strokeWidth = 4
        }
    )
    mediumButton.x = display.contentCenterX
    mediumButton.y = display.contentCenterY-20
    uiGroup:insert(mediumButton)

--- Create Hard button
    local hardButton = widget.newButton(
        {
            label = "HARD", fontSize=30, font="Arial Black",
            labelColor = {default={ 1, 1, 1 }, over={ 1, 1, 1 }}, 
            onEvent = gotoHard,
            shape = "roundedRect",
            width = 170,
            height = 40,
            cornerRadius = 2,
            fillColor = {default={1,0.4,0.5}, over={0,0,0}},
            strokeColor = {default={0.9,0,0.4}, over={0,0,0}},
            strokeWidth = 4
        }
    )
    hardButton.x = display.contentCenterX
    hardButton.y = display.contentCenterY+60
    uiGroup:insert(hardButton)

--- EVENT LISTENER
	easyButton:addEventListener( "tap", gotoEasy )      --Add Event Listener on Easy button
    mediumButton:addEventListener( "tap", gotoMedium )  --Add Event Listener on Medium button
    hardButton:addEventListener( "tap", gotoHard )      --Add Event Listener on Hard button
    
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
