// BALL_LOGIC
// 	MODULE TO MOVE BALL BASED ON VELOCITY AND CHECKS FOR SCORING
// VERSION: 1.0.0
// LAST UPDATED: MAR 15, 2026
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
	
	inout reg [11:0] ballX,					// THE X POSITION OF THE BALL
	inout reg [11:0] ballY,					// THE Y POSITION OF THE BALL
	inout reg [1:0] ballXVel,				// THE VELOCITY OF THE BALL IN THE X DIRECTION
	inout reg [1:0] ballYVel,				// THE VELOCITY OF THE BALL IN THE Y DIRECTION
		
	input playerOneUp,
	input playerOneDown,
	
	input playerTwoUp,
	input playerTwoDown,
		 
		 
	inout reg [11:0] blockerOneY,			// THE Y POSITION OF THE BLOCKER FOR PLAYER ONE
	inout reg [11:0] blockerTwoY,			// THE Y POSITION OF THE BLOCKER FOR PLAYER TWO
		
	inout reg [6:0] scoreOne,				// THE SCORE FOR PLAYER ONE
	inout reg [6:0] scoreTwo,				// THE SCORE FOR PLAYER TWO
	
	inout reg [1:0] launchMode				// THE LAUNCH MODE (0 NOT IN LAUNCH MODE, 1 PLAYER ONE LAUNCH MODE, 2 PLAYER TWO LAUNCH MODE) 
);
	reg [31:0] clkCount = 0;				// THE COUNT OF THE CLOCK CYCLES

	initial begin
		ballX <= (BLOCKER_PADDING + BLOCKER_WIDTH + BALL_SIZE); 	// SETTING THE INITIAL BALL X POSITION
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
	
	always @(posedge clk25) begin
		// RESET BACK TO DEFAULT STATE
		if (rst) begin
			ballX <= (BLOCKER_PADDING + BLOCKER_WIDTH + BALL_SIZE); 	// SETTING THE INITIAL BALL X POSITION
			ballY <= (BOARD_HEIGHT / 2);										// SETTING THE INITIAL BALL Y POSITION
			ballXVel <= 0;															// THE INITITAL BALL VELOCITY (0)
			ballYVel <= 0;															// THE INITITAL BALL VELOCITY (0)
				
			blockerOneY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER ONE
			blockerTwoY <= (BOARD_HEIGHT / 2);								// THE INITITAL BLOCKER Y POSITION FOR PLAYER TWO
				
			scoreOne <= 0;															// THE INITAL SCORE FOR PLAYER ONE
			scoreTwo <= 0;															// THE INITAL SCORE FOR PLAYER TWO
			
			launchMode <= 1;														// THE INITAL LAUNCH MODE (PLAYER ONE START WITH PLAY)
			
			clkCount <= 0;															// THE INITAL CLOCK COUNT
		// LOOP THAT RUNS EVERY HALF SECOND
		end else if (clkCount >= (CLK_SIZE/8)) begin	
				clkCount <= 0;
				
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
							
							launchMode <= 2;
							ballX <= BOARD_WIDTH - BLOCKER_PADDING - BALL_SIZE;
							ballY <= blockerTwoY;
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
							
							launchMode <= 1;
							ballX <= BLOCKER_PADDING + BALL_SIZE;
							ballY <= blockerOneY;
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
				
				// MOVE BLOCKER
				if (playerOneUp && playerOneDown) begin
					if (launchMode == 1) begin
						ballX <= 1;
						if (ballY >= (BOARD_HEIGHT/2)) begin
							ballYVel <= 1;
						end else begin
							ballYVel <= 2;
						end
					end
				end else if (playerOneUp) begin
					if ((blockerOneY + BLOCKER_SIZE) < BOARD_HEIGHT) begin
							blockerOneY <= blockerOneY + 1;
							
							if (launchMode == 1) begin
								ballY <=  ballY + 1;
							end
					end
				end else if (playerOneDown) begin
					if ((blockerOneY - BLOCKER_SIZE) > 0) begin
						blockerOneY <= blockerOneY - 1;
						
						
						if (launchMode == 1) begin
							ballY <=  ballY - 1;
						end
					end
				end
					
				if (playerOneUp && playerOneDown) begin
					if (launchMode == 2) begin
						ballX <= 2;
						if (ballY >= (BOARD_HEIGHT/2)) begin
							ballYVel <= 1;
						end else begin
							ballYVel <= 2;
						end
					end
				end else if (playerTwoUp) begin
					if ((blockerTwoY + BLOCKER_SIZE) < BOARD_HEIGHT) begin
						blockerTwoY <= blockerTwoY + 1;
							
						if (launchMode == 2) begin
							ballY <=  ballY + 1;
						end
					end
				end else if (playerTwoDown) begin
					if ((blockerTwoY - BLOCKER_SIZE) > 0) begin
						blockerTwoY <= blockerTwoY - 1;
						
						if (launchMode == 2) begin
								ballY <=  ballY - 1;
						end
					end
				end
		end else begin
			clkCount <= clkCount + 1;
		end
	end
endmodule
