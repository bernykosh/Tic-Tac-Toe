-----------------------------------------------------------------
--STUDENT NAME  :   BERNEDETTE KOSHILA PERERA           
--STUDENT ID    :   10449314                             
--UNIT TITLE    :   MOBILE APPLICATIONS DEVELOPMENT     
--UNIT CODE     :   CSG3303                             
--ASSIGNMENT 02 :   CUMULATIVE MODIFICATION OF CODE      
--CAMPUS        :   ACBT / COLOMBO
--SCENE 		:	MENU SCREEN                     
-----------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--- GO TO LEVEL SCENE
local function gotoLevel()
	composer.gotoScene("level", { time=800, effect="fromLeft" })
end

--- GO TO SCORES SCENE
local function gotoScores()
    composer.gotoScene( "gameScore", { time=800, effect="crossFade" } )
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
	
--- TicTacToe title
	local title = display.newImageRect( sceneGroup, "images/title.png", 280, 90 )
    title.x = display.contentCenterX
    title.y = 90

--- Image
	local picture = display.newImageRect( sceneGroup, "images/picture.png", 200, 200 )
    picture.x = display.contentCenterX
    picture.y = 250

--- Start Button
	local startButton = display.newImageRect( sceneGroup, "images/start.png", 150, 100  )
    startButton.x = display.contentCenterX
	startButton.y = 390

--- Score Button
	local scoreButton = display.newImageRect( sceneGroup, "images/hscore.png", 145, 55  )
    scoreButton.x = display.contentCenterX
	scoreButton.y = 457

--- Event listener on start button - Goes to the Level scene
	startButton:addEventListener( "tap", gotoLevel )
--- Event listener on score button - Goes to the Scores scene
	scoreButton:addEventListener( "tap", gotoScores )
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
