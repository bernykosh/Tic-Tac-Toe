--------------------------------------------------------------------------------------------------------------------
-- When the player restarts the game, this is the loading screen when the restart button is pressed.
-- SCENE : RESTARTING SCREEN                
--------------------------------------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

--- Go To Game Scene
local function gotoGame()
	composer.gotoScene("game", { time=800, effect="crossFade" })
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

--- Background image
	local background = display.newImageRect( sceneGroup, "background.png", 400, 800 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

--- Restarting Text
	local load = display.newImageRect( sceneGroup, "images/load.png", 285, 60 )
    load.x = display.contentCenterX
    load.y = 230

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		timer.performWithDelay(1100, gotoGame) 	--Goes back to the Game scene in few seconds
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		 composer.removeScene("load")

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
