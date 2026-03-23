// BALL_LOGIC
// 	MODULE TO MOVE BALL BASED ON VELOCITY AND CHECKS FOR SCORING
// VERSION: 1.0.2
// LAST UPDATED: MAR 22, 2026
// AUTHOR(s): DOMENIC CHAO, Augustine Eyolfson

module BALL_LOGIC #(
	parameter CLK_SIZE = 25000000,		// THE SIZE OF THE CLOCK
	parameter BOARD_WIDTH = 640,			// THE WIDTH OF THE BOARD
	parameter BOARD_HEIGHT = 480,			// THE HEIGHT OF THE BOARD
	
	parameter BALL_SIZE = 9,				// THE SIZE OF THE BALL ON ONE SIZE
	
	parameter BLOCKER_WIDTH = 5,			// THE WIDTH OF THE BLOCKER
	parameter BLOCKER_SIZE = 20,			// THE HEIGHT OF THE BLOCKER 
	parameter BLOCKER_PADDING = 10		// THE PADDING IN THE BACK OF THE BLOCKER
)(
	input clk25,								// THE CLOCK INPUT (25MHZ)
	input rst,									// RESET INPUT
	input paused,								// IF THE GAME IS PAUSED
	inout reg mainMenu,						// IF THE GAME IS IN THE MAIN MENU
	inout reg gameMode,						// IF THE GAME IS UNLIMATED OR FIRST TO 3; 0 FOR ULIMATED AND 1 FOR FIRST TO 3
	inout reg gameOver,						// IF THE GAME IS OVER
	
	inout reg [11:0] ballX,					// THE X POSITION OF THE BALL
	inout reg [11:0] ballY,					// THE Y POSITION OF THE BALL
	inout reg [1:0] ballXVel,				// THE VELOCITY OF THE BALL IN THE X DIRECTION
	inout reg [1:0] ballYVel,				// THE VELOCITY OF THE BALL IN THE Y DIRECTION
		
	input playerOneUp,						// IF PLAYER ONE IS MOVING UP
	input playerOneDown,						// IF PLAYER ONE IS MOVING DOWN
	
	input playerTwoUp,						// IF PLAYER TWO IS MOVING UP
	input playerTwoDown,						// IF PLAYER TWO IS MOVING DOWN
		 
	inout reg [11:0] blockerOneY,			// THE Y POSITION OF THE BLOCKER FOR PLAYER ONE
	inout reg [11:0] blockerTwoY,			// THE Y POSITION OF THE BLOCKER FOR PLAYER TWO
		
	inout reg [6:0] scoreOne,				// THE SCORE FOR PLAYER ONE
	inout reg [6:0] scoreTwo,				// THE SCORE FOR PLAYER TWO
	
	inout reg [1:0] launchMode				// THE LAUNCH MODE (0 NOT IN LAUNCH MODE, 1 PLAYER ONE LAUNCH MODE, 2 PLAYER TWO LAUNCH MODE) 
);
	reg [31:0] clkCount = 0;				// THE COUNT OF THE CLOCK CYCLES
	reg lastScoredOn;							// THE PLAYER WHO WAS LAST SCORED ON 
	reg scoredThisFrame;						// IF SOMEONE SCORED THIS FRAME
	
	initial begin
		mainMenu <= 1;															// STARTING ON MAIN MENU
		gameMode <= 0;															// RETURNING TO DEFAULT STATE FOR GAME MODE
		gameOver <= 0;															// ENSURING GAME IS NOT OVER
		
		ballX <= (BLOCKER_PADDING + BALL_SIZE) + 1; 					// SETTING THE INITIAL BALL X POSITION
		ballY <= (BOARD_HEIGHT / 2);										// SETTING THE INITIAL BALL Y POSITION
		ballXVel <= 0;															// THE INITITAL BALL VELOCITY (0)
		ballYVel <= 0;															// THE INITITAL BALL VELOCITY (0)
			
		blockerOneY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER ONE
		blockerTwoY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER TWO
			
		scoreOne <= 0;															// THE INITAL SCORE FOR PLAYER ONE
		scoreTwo <= 0;															// THE INITAL SCORE FOR PLAYER TWO
		
		launchMode <= 1;														// THE INITAL LAUNCH MODE (PLAYER ONE START WITH PLAY)
		
		clkCount <= 0;															// THE INITAL CLOCK COUNT
		
		scoredThisFrame <= 0;
	end
	
	always @(posedge clk25) begin
		// RESET BACK TO DEFAULT STATE
		if (rst) begin
			mainMenu <= 1;															// RETURN TO MAIN MENU
			gameMode <= 0;															// RETURNING TO DEFAULT STATE FOR GAME MODE
			gameOver <= 0;															// ENSURING GAME IS NOT OVER
			
			ballX <= (BLOCKER_PADDING + BALL_SIZE) + 1; 					// SETTING THE INITIAL BALL X POSITION
			ballY <= (BOARD_HEIGHT / 2);										// SETTING THE INITIAL BALL Y POSITION
			ballXVel <= 0;															// THE INITITAL BALL VELOCITY (0)
			ballYVel <= 0;															// THE INITITAL BALL VELOCITY (0)
				
			blockerOneY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER ONE
			blockerTwoY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER TWO
				
			scoreOne <= 0;															// THE INITAL SCORE FOR PLAYER ONE
			scoreTwo <= 0;															// THE INITAL SCORE FOR PLAYER TWO
			
			launchMode <= 1;														// THE INITAL LAUNCH MODE (PLAYER ONE START WITH PLAY)
			
			clkCount <= 0;															// THE INITAL CLOCK COUNT
			scoredThisFrame <= 0;
		// LOOP THAT RUNS IF WE ARE IN MAIN MENU MODE
		end else if (mainMenu) begin
			if (playerOneDown) begin
				mainMenu <= 0;
				gameMode <= 1;
			end else if (playerOneUp) begin
				mainMenu <= 0;
				gameMode <= 0;
			end
		// LOOP THAT WAITS FOR INPUT BEFORE RESTARTING
		end else if (gameOver) begin
			if (playerOneUp || playerOneDown) begin
				mainMenu <= 1;															// RETURN TO MAIN MENU
				gameMode <= 0;															// RETURNING TO DEFAULT STATE FOR GAME MODE
				gameOver <= 0;															// ENSURING GAME IS NOT OVER
				
				ballX <= (BLOCKER_PADDING + BALL_SIZE) + 1; 					// SETTING THE INITIAL BALL X POSITION
				ballY <= (BOARD_HEIGHT / 2);										// SETTING THE INITIAL BALL Y POSITION
				ballXVel <= 0;															// THE INITITAL BALL VELOCITY (0)
				ballYVel <= 0;															// THE INITITAL BALL VELOCITY (0)
					
				blockerOneY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER ONE
				blockerTwoY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER TWO
					
				scoreOne <= 0;															// THE INITAL SCORE FOR PLAYER ONE
				scoreTwo <= 0;															// THE INITAL SCORE FOR PLAYER TWO
				
				launchMode <= 1;														// THE INITAL LAUNCH MODE (PLAYER ONE START WITH PLAY)
				
				clkCount <= 0;															// THE INITAL CLOCK COUNT
			end
		// LOOP THAT RUNS EVERY HALF SECOND
		end else if (clkCount >= (CLK_SIZE/16) && !paused) begin	
				clkCount <= 0;
			
				if (scoredThisFrame) begin
					scoredThisFrame <= 0;
					if (lastScoredOn == 0) begin
						launchMode <= 1;
						ballY <= blockerOneY;
					end else begin
						launchMode <= 2;
						ballY <= blockerTwoY;
					end
					
					if (gameMode) begin
						if (scoreOne >= 3 | scoreTwo >= 3) begin
							gameOver <= 1;
						end
					end
				end
				
				
				if (launchMode == 0) begin
					// CHECKING IF BALL HAS HIT TOP OR BOTTOM OF BOARD
					if ((ballY + BALL_SIZE) >= BOARD_HEIGHT) begin
						// HIT TOP
						ballYVel <= 2;
					end else if ((ballY - BALL_SIZE) <= 0) begin
						// HIT BOTTOM
						ballYVel <= 1;
					end
					
					// CHECKING IF BALL HAS SCORED OR HIT BLOCKER
					if ((ballX + BALL_SIZE) >= (BOARD_WIDTH - BLOCKER_PADDING)) begin
						if (((ballY + BALL_SIZE) <= (blockerTwoY + BLOCKER_SIZE)) && ((ballY + BALL_SIZE) >= (blockerTwoY - BLOCKER_SIZE))) begin
							// HIT PLAYER TWO BLOCKER
							ballXVel <= 2;
						end else begin
							// SCORED ON PLAYER TWO
							// PLAYER TWO WILL START WITH BALL AFTER
							ballXVel <= 0;
							ballYVel	<= 0;
							scoreOne <= scoreOne + 1;
							ballX <= BOARD_WIDTH - BLOCKER_PADDING - BALL_SIZE - 1;
							ballY <= blockerTwoY;
							launchMode <= 3;
							lastScoredOn <= 1;
							scoredThisFrame <= 1;
						end
					end else if ((ballX - BALL_SIZE) <= (BLOCKER_PADDING)) begin
						if (((ballY + BALL_SIZE) <= (blockerOneY + BLOCKER_SIZE)) && ((ballY + BALL_SIZE) >= (blockerOneY - BLOCKER_SIZE))) begin
							// HIT PLAYER ONE BLOCKER
							ballXVel <= 1;
						end else begin
							// SCORED ON PLAYER ONE
							// PLAYER ONE WILL START WITH BALL AFTER
							ballXVel <= 0;
							ballYVel	<= 0;
							scoreTwo <= scoreTwo + 1;
							
							ballX <= BLOCKER_PADDING + BALL_SIZE + 1;
							ballY <= blockerOneY;
							launchMode <= 3;
							lastScoredOn <= 0;
							scoredThisFrame <= 1;
						end
					end
					
					// MOVING BALL BASED ON CURRENT VELOCITY
					if (ballXVel == 1) begin
						ballX <= ballX + 1;
					end else if (ballXVel == 2) begin
						ballX <= ballX - 1;
					end
					
					if (ballYVel == 1) begin
						ballY <= ballY + 1;
					end else if (ballYVel == 2) begin
						ballY <= ballY - 1;
					end

				end
				
				// MOVE BLOCKER FOR PLAYER ONE
				if (scoredThisFrame == 0 && launchMode < 3) begin 
					if (playerOneUp && playerOneDown) begin
						// LAUCHING THE BALL
						if (launchMode == 1) begin
							launchMode <= 0;
							ballXVel <= 1;
							
							if (ballY >= (BOARD_HEIGHT/2)) begin
								ballYVel <= 1;
							end else begin
								ballYVel <= 2;
							end
						end
					end else if (playerOneUp) begin
						// MOVING PLAYER ONE BLOCKER UP
						if ((blockerOneY + BLOCKER_SIZE) < BOARD_HEIGHT) begin
								blockerOneY <= blockerOneY + 1;
								
								
								// MOVING THE BALL IF ITS IN LAUNCH MODE
								if (launchMode == 1) begin
									ballY <=  ballY + 1;
								end
						end
					end else if (playerOneDown) begin
						// MOVING PLAYER ONE BLOCKER UP
						if ((blockerOneY - BLOCKER_SIZE) > 0) begin
							blockerOneY <= blockerOneY - 1;
							
							
							// MOVING THE BALL IF ITS IN LAUNCH MODE
							if (launchMode == 1) begin
								ballY <=  ballY - 1;
							end
						end
					end
						
					// MOVE BLOCKER FOR PLAYER TWO	
					if (playerTwoUp && playerTwoDown) begin
						// LAUNCHING THE BALL
						if (launchMode == 2) begin
							launchMode <= 0;
							ballXVel <= 2;
							
							if (ballY >= (BOARD_HEIGHT/2)) begin
								ballYVel <= 1;
							end else begin
								ballYVel <= 2;
							end
						end
					end else if (playerTwoUp) begin
						// MOVING PLAYER TWO BLOCKER UP
						if ((blockerTwoY + BLOCKER_SIZE) < BOARD_HEIGHT) begin
							blockerTwoY <= blockerTwoY + 1;
							
							// MOVING THE BALL IF IT IN PLAYER TWO LAUNCH MODE
							if (launchMode == 2) begin
								ballY <=  ballY + 1;
							end
						end
					end else if (playerTwoDown) begin
						// MOVING PLAYER TWO BLOCKER DOWN
						if ((blockerTwoY - BLOCKER_SIZE) > 0) begin
							blockerTwoY <= blockerTwoY - 1;
							
							
							// MOVING THE BALL IF IT IN PLAYER TWO LAUNCH MODE
							if (launchMode == 2) begin
									ballY <=  ballY - 1;
							end
						end
					end
				end
		end else if (!paused) begin
			clkCount <= clkCount + 1;
		end
	end
endmodule
