// PONG
// 	THE TOP MODULE FOR THE PROJECT
// VERSION: 1.0.1
// LAST UPDATED: MAR 17, 2026
// AUTHOR(S): DOMENIC CHAO, Leon Fust, Israel Igbinawan, Augustine Eyolfson

module PONG (	
	// SW INPUT
	input	pause,						// SW[0]		PIN_AF14
	input rst,							// SW[9] 	PIN_AA30
	
	// CLK INPUTS
	input clk50,						// CLOCK_50	PIN_AF14
	
	// PUSH BTN INPUTS
	input playerOneUp,				// KEY[3] 	PIN_AA15
	input playerTwoUp,				// KEY[1] 	PIN_AK4
	input playerOneDown,				// KEY[2] 	PIN_AA14
	input playerTwoDown,				// KEY[0] 	PIN_AJ4
	
	// SEVEN SEGMENT OUTPUTS
	output [6:0] sevSegP1L,			// HEX[5]	[6: PIN_AB21; 5: PIN_AF19; 4: PIN_AE19; 3: PIN_AG20; 2: PIN_AF20; 1: PIN_AG21; 0: PIN_AF21;]
	output [6:0] sevSegP1C,			// HEX[4]	[6: PIN_AH22; 5: PIN_AF23; 4: PIN_AG23; 3: PIN_AE23; 2: PIN_AE22; 1: PIN_AG22; 0: PIN_AD21;]
	output [6:0] sevSegP1R,			//	HEX[3] 	[6: PIN_AD20; 5: PIN_AA19; 4: PIN_AC20; 3: PIN_AA20; 2: PIN_AD19; 1: PIN_W19; 0: PIN_Y19;]
	output [6:0] sevSegP2L,			// HEX[2] 	[6: PIN_W16; 5: PIN_AF18; 4: PIN_Y18; 3: PIN_Y17; 2: PIN_AA18; 1: PIN_AB17; 0: PIN_AA21;]
	output [6:0] sevSegP2C,			// HEX[1]	[6: PIN_V17; 5: PIN_AE17; 4: PIN_AE18; 3: PIN_AD17; 2: PIN_AE16; 1: PIN_V16; 0: PIN_AF16;]
	output [6:0] sevSegP2R,			// HEX[0]	[6: PIN_AH18; 5: PIN_AG18; 4: PIN_AH17; 3: PIN_AG16; 2: PIN_AG17; 1: PIN_V18; 0: PIN_W17;]	
	
	// VGA OUPUT
	output [7:0] vgaR,				// VGA_R		[7: PIN_AJ26; 6: PIN_AG26; 5: PIN_AF26; 4: PIN_AH27; 3: PIN_AJ27; 2: PIN_AK27; 1: PIN_AK28; 0: PIN_AK29;]
	output [7:0] vgaG,				// VGA_G 	[7: PIN_AH23; 6: PIN_AK23; 5: PIN_AH24; 4: PIN_AJ24; 3: PIN_AK24; 2: PIN_AH25; 1: PIN_AJ25; 0: PIN_AK26;]
	output [7:0] vgaB,				// VGA_B		[7: PIN_AK16; 6: PIN_AJ16; 5: PIN_AJ17; 4: PIN_AH19; 3: PIN_AJ19; 2: PIN_AH20; 1: PIN_AJ20; 0: PIN_AJ21;]
	output vgaHSync,					//	VGA HSYC	[PIN_AK19]
	output vgaVSync,					// VGA VSYC	[PIN_AK18]
	output vga_clk						// VGA_CLK	[PIN_AK21]
);	

	// LOCAL PARAMETERS
	localparam SCREEN_WIDTH = 640;											// THE WIDTH OF THE SCREEN
	localparam SCREEN_HEIGHT = 480; 											// THE HEIGHT OF THE SCREEN
		
	localparam BLOCKER_PADDING = 15;											// THE PADDING BEHIND THE BLOCKER
	localparam BLOCKER_WIDTH = 5;												// THE WIDTH OF THE BLOCKER
	localparam BLOCKER_HEIGHT = 20;											// THE HEIGHT OF THE BLOCKER
	
	localparam BALL_SIZE = 5;													// THE SIZE OF THE BALL IN ANY ONE DIRECTION
	
	localparam CLK_SIZE = 2500000;											// THE SIZE OF THE 25 MHZ CLOCK
	
	reg clk25 = 0;																	// THE STATE OF THE 25 MHZ CLOCK
		
	wire [11:0] ballX;															// THE X POSITION OF THE BAL
	wire [11:0] ballY;															// THE Y POSITION OF THE BALL
	wire [1:0] ballXVel;															// THE BALL VELOCITY IN THE X DIRECTION (O IS NONE, 1 IS RIGHT, 2 IS LEFT)
	wire [1:0] ballYVel;															// THE BALL VELOCITY IN THE Y DIRECTION (0 IS NONE, 1 IS UP, 2 IS DOWN)
		
	wire [11:0] blockerOneY;													// THE Y POSITION OF THE PLAYER ONE BLOCKER
	wire [11:0] blockerTwoY;													// THE Y POSITION OF THE PLAYER TWO BLOCKER
	
	wire [6:0] 	scoreOne;														// THE SCORE OF PLAYER ONE
	wire [6:0] 	scoreTwo;														// THE SCORE OF PLAYER TWO
	
	wire [23:0] backgroundCol = 	24'b000000000000000001111101;		// THE BACKGROUND COLOR OF THE BOARD (BLACK)
	wire [23:0] objectCol = 		24'b111111111111111111111111;		// THE COLOR OF THE OBJECT (WHITE)
	
	wire [1:0] launchMode;														// WHO SHOULD LAUNCH THE BALL (0 = NOT IN LAUNCH MODE, 1 = PLAYER ONE LAUNCH MODE, 2 = PLAYER TWO LAUNCH MODE)
	wire mainMenu;																	// IF THE GAME IS IN THE MAIN MENU
	wire gameMode;																	// IF THE GAME IS UNLIMATED OR FIRST TO 3; 0 FOR ULIMATED AND 1 FOR FIRST TO 3
	wire gameOver;																	// IF THE GAME IS OVER

	wire playerOneMoveUp;
	wire playerOneMoveDown;
	wire playerTwoMoveUp;
	wire playerTwoMoveDown;
	
	
	assign gamemode = gameMode;
	
	//CREATING 25MHZ CLOCK FROM 50
	always @(posedge clk50) begin
		clk25 <= !clk25;
	end
	
	assign vga_clk = clk25;
		
	// SCORE OUTPUT
	// PLAYER ONE IS LEFT 3 [HEX 5,4,3]
	NUM_TO_SEVSEG playerOneScore (
		.number(scoreOne),
		.sevSegL(sevSegP1L),
		.sevSegC(sevSegP1C),
		.sevSegR(sevSegP1R)
	);
	
	// SCORE OUTPUT
	// PLAYER TWO IS RIGHT 3 [HEX 2,1,0]
	NUM_TO_SEVSEG playerTwoScore (
		.number(scoreTwo),
		.sevSegL(sevSegP2L),
		.sevSegC(sevSegP2C),
		.sevSegR(sevSegP2R)
	);

	// LOGIC FOR MOVING BALL AROUND
	BALL_LOGIC #(
		.CLK_SIZE(CLK_SIZE),
		.BOARD_WIDTH(SCREEN_WIDTH),
		.BOARD_HEIGHT(SCREEN_HEIGHT),
	
		.BALL_SIZE(BALL_SIZE),
	
		.BLOCKER_WIDTH(BLOCKER_WIDTH),
		.BLOCKER_SIZE(BLOCKER_HEIGHT),
		.BLOCKER_PADDING(BLOCKER_PADDING)
	) ballLogic (
		.ballX(ballX),
		.ballY(ballY),
		.ballXVel(ballXVel),
		.ballYVel(ballYVel),
		
		
		.playerOneUp(playerOneMoveUp),
		.playerOneDown(playerOneMoveDown),
		
		.playerTwoUp(playerTwoMoveUp),
		.playerTwoDown(playerTwoMoveDown),
		
		.blockerOneY(blockerOneY),
		.blockerTwoY(blockerTwoY),
		
		.scoreOne(scoreOne),
		.scoreTwo(scoreTwo),
		
		.launchMode(launchMode),
		
		.clk25(clk25),
		.rst(rst),
		.paused(pause),
		.mainMenu(mainMenu),
		.gameMode(gameMode),
		.gameOver(gameOver)
	);
	
	// VGA OUTPUTS TO MONITOR
	VGA_OUTPUT #(
		.BOARD_WIDTH(SCREEN_WIDTH),
		.BOARD_HEIGHT(SCREEN_HEIGHT),
	
		.BALL_SIZE(BALL_SIZE),
	
		.BLOCKER_SIZE(BLOCKER_HEIGHT),
		.BLOCKER_PADDING(BLOCKER_PADDING),
		.BLOCKER_WIDTH(BLOCKER_WIDTH),
	
		.CENTRE_ROW_BETWEEN(10),
		.CENTRE_WIDTH(5)
	) displayOutput (
		.ballX(ballX),
		.ballY(ballY),
		
		.blockerOneY(blockerOneY),
		.blockerTwoY(blockerTwoY),
		
		.scoreOne(scoreOne),
		.scoreTwo(scoreTwo),
		
		.backgroundCol(backgroundCol),
		.objectCol(objectCol),
		
		.clk25(clk25),
		.rst(rst),
		.paused(pause),
		.mainMenu(mainMenu),
		.gameOver(gameOver),
		
		.vgaR(vgaR),
		.vgaG(vgaG),
		.vgaB(vgaB),
		.vgaHSYNC(vgaHSync),
		.vgaVSYNC(vgaVSync),
	);
	
	
	// PUSH BUTTON INPUTS AND ACTIONS BASED ON INPUTS
	PUSH_BTN_INPUT p1_inputs (
		.upBtn(playerOneUp),
		.downBtn(playerOneDown),
		
		.moveUp(playerOneMoveUp),
		.moveDown(playerOneMoveDown)
	);
	
	PUSH_BTN_INPUT p2_inputs (
		.upBtn(playerTwoUp),
		.downBtn(playerTwoDown),
		
		.moveUp(playerTwoMoveUp),
		.moveDown(playerTwoMoveDown)
	);
endmodule

