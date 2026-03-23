// VGA_OUTPUT
// 	MODULE TO DETERMINE PIXEL COLOR (OBJECT VS NO OBJECT) 
//			AND THEN DISPLAY TO DATA TO SCREEN
// VERSION: 1.0.3
// LAST UPDATED: MAR 22, 2026
// AUTHOR: DOMENIC CHAO

module VGA_OUTPUT #(
	parameter BOARD_WIDTH = 640, 				// THE WIDTH OF THE BOARD
	parameter BOARD_HEIGHT = 480,				// MTHE HEIGHT OF THE BOARD
	
	parameter BALL_SIZE = 9,					// THE NUMBER OF PIXELS ANY DIRECTION AROUND THE CENTRE
	
	parameter BLOCKER_SIZE = 20,				// THE HEIGHT OF THE BLOCKER ON ONE SIDE OF CENTRE
	parameter BLOCKER_PADDING = 10,			// THE PADDING BETWEEN THE BACK SIDE OF THE BLOCKER
	parameter BLOCKER_WIDTH = 5,				// THE WIDTH OF THE BLOCK ON ONE SIDE OF CENTRE
	
	parameter CENTRE_ROW_BETWEEN = 10,		// THE NUMBER OF ROWS THAT ARE BETWEEN EACH COLOR OF THE CENTRE LINE
	parameter CENTRE_WIDTH = 5					// THE WIDTH OF THE CENTRE LINE	
)(
	input [11:0] ballX,							// THE X POSITION OF THE BALL
	input [11:0] ballY,							// THE Y POSITION OF THE BALL
		
	input [11:0] blockerOneY,					// THE Y POSITION OF THE BLOCKER FOR PLAYER ONE
	input [11:0] blockerTwoY,					// THE Y POSITION OF THE BLOCKER FOR PLAYER TWO
		
	input [6:0] scoreOne,						// PLAYER ONE SCORE
	input [6:0] scoreTwo,						// PLAYER TWO SCORE
	
	input [23:0] backgroundCol,				// THE COLOR OF THE BACKGROUND
	input [23:0] objectCol,						// THE COLOR OF THE OBJECTS ON THE BOARD

	input clk25,									// 25MHZ CLOCK
	
	input rst,										// RESET INPUT
	input paused,									// PUASE INPUT
	input mainMenu,								// IS MAIN MENU ACTIVE
	input gameOver,								// IS THE GAME OVER
	
	output reg [7:0] vgaR, 						// VGA RED COLOR OUTPUT (0-255)
	output reg [7:0] vgaG,						// VGA GREEN COLOR OUTPUT (0-255)
	output reg [7:0] vgaB,						// VGA BLUE COLOR OUTPUT (0-255)
	output vgaHSYNC,								// VGA HORIZONTAL SYNC OUTPUT 
	output vgaVSYNC								// VGA VERTICAL SYNC OUTPUT
);

	// VARIABLES FOR HEIGHT AND WIDTH
   localparam H_ACTIVE = BOARD_WIDTH;
   localparam V_ACTIVE = BOARD_HEIGHT;
	
   localparam H_FRONT_P = 16;
	localparam V_FRONT_P = 10;
	
	localparam H_SYNC = 96;
	localparam V_SYNC = 2;
	
	localparam H_BACK_P = 48;
	localparam V_BACK_P = 33;
	
	localparam H_TOTAL = H_ACTIVE + H_FRONT_P + H_SYNC + H_BACK_P;
   localparam V_TOTAL = V_ACTIVE + V_FRONT_P + V_SYNC + V_BACK_P;
	
	// TEMPORARY HEIGHT AND WIDTH VARIABLE
	reg [11:0] Hpos = 0;
	reg [11:0] Vpos = 0;
	wire videoActive;
	
	reg [5:0] rowChange = 0;
	reg centreCol = 0;
	
	reg object = 0;

	reg [11:0] xOffset = 0;
	reg [11:0] yOffset = 0;
	reg [11:0] ascii = 0;
	wire isColorLarge;
	
	reg [11:0] xOffsetNum = 0;
	reg [11:0] yOffsetNum = 0;
	reg [11:0] asciiNum = 0;
	wire isColorNum;
	
	reg [11:0] xOffsetSml = 0;
	reg [11:0] yOffsetSml = 0;
	reg [11:0] asciiSml= 0;
	wire isColorSml;
	
	reg [11:0] scoreOneDigitOne = 0;
	reg [11:0] scoreOneDigitTwo = 0;
	reg [11:0] scoreTwoDigitOne = 0;
	reg [11:0] scoreTwoDigitTwo = 0;
	
	 CHAR_TO_VGA #(
		.HEIGHT(180),
		.WIDTH(100)
	) largeFont (
		.ascii(ascii),
		.xPos(xOffset),
		.yPos(yOffset),
		.isColor(isColorLarge)
	);
	
	CHAR_TO_VGA #(
		.HEIGHT(144),
		.WIDTH(80)
	) numFont (
		.ascii(asciiNum),
		.xPos(xOffsetNum),
		.yPos(yOffsetNum),
		.isColor(isColorNum)
	);
	
	CHAR_TO_VGA #(
		.HEIGHT(45),
		.WIDTH(25)
	) smlFont (
		.ascii(asciiSml),
		.xPos(xOffsetSml),
		.yPos(yOffsetSml),
		.isColor(isColorSml)
	);
	
	
	// UPDATING THE VERTICAL AND HORIZONTAL POSITION
	always @(posedge clk25) begin
		if (rst) begin
			Hpos <= 0;
			Vpos <= 0;
		end else	if (Hpos < H_TOTAL - 1) begin
			// UPDATING HORIZONTAL POSITION
			Hpos <= Hpos + 1;
		end else begin
			Hpos <= 0;
			
			// DETERMINE IF WE NEED TO DRAW THE CENTRE LINE OR NOT AT THIS ROW
			if (rowChange >= CENTRE_ROW_BETWEEN) begin
				rowChange <= 0;
				centreCol <= !centreCol;
			end else begin
				rowChange <= rowChange + 1;
			end
			
			// UPDATING VERTICAL POSITION
			if (Vpos < V_TOTAL - 1) begin
				Vpos <= Vpos + 1;
			end else begin
				rowChange <= 0;
				centreCol <= 0;
				Vpos <= 0;
			end
		end
	end
	
	// HORIZONTAL SYNCING
	assign vgaHSYNC = rst ? 1'b1 :  ~((Hpos >= (H_ACTIVE + H_FRONT_P) && Hpos < (H_ACTIVE + H_FRONT_P + H_SYNC)));
		
	// VERTICAL SYNCING
	assign vgaVSYNC = rst ? 1'b1 : ~((Vpos >= (V_ACTIVE + V_FRONT_P) && Vpos < (V_ACTIVE + V_FRONT_P + V_SYNC)));
		
	assign videoActive = (Hpos < H_ACTIVE) && (Vpos < V_ACTIVE);
	
	// COLOR LOGIC
	always @(posedge clk25) begin
		object <= 0;
		
		// DETERMINE IF THERE IS OBJECT AT THIS PIXEL OR NOT
		if (mainMenu) begin
			// PONG WORDS
			if (Hpos >= 40 && Hpos < 140 && Vpos >= 50 && Vpos <= 230) begin
				xOffset <= Hpos - 40;
				yOffset <= Vpos - 50;
				ascii <= 12'd80;
			end else if (Hpos >= 160 && Hpos < 260 && Vpos >= 50 && Vpos <= 230) begin
				xOffset <= Hpos - 160;
				yOffset <= Vpos - 50;
				ascii <= 12'd79;
			end else if (Hpos >= 280 && Hpos < 380 && Vpos >= 50 && Vpos <= 230) begin
				xOffset <= Hpos - 280;
				yOffset <= Vpos - 50;
				ascii <= 12'd78;
			end else	if (Hpos >= 400 && Hpos < 500 && Vpos >= 50 && Vpos <= 230) begin
				xOffset <= Hpos - 400;
				yOffset <= Vpos - 50;
				ascii <= 12'd71;
			end else begin
				ascii <= 0;
			end
			
			// MENU OPTIONS
			// UP: FIRST TO 3
			if (Hpos >= 100 && Hpos < 125 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 100;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd85;
			end else if (Hpos >= 135 && Hpos < 160 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 135;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd80;
			end else if (Hpos >=  170 && Hpos < 195 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 170;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd58;
			end else	if (Hpos >=  205 && Hpos < 230  && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 205;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd00;
			end else	if (Hpos >=  240 && Hpos < 265 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 240;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd70;	
			end else	if (Hpos >=  275 && Hpos < 300 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 275;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd73;
			end else	if (Hpos >= 310 && Hpos < 335 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 310;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd82;
			end else	if (Hpos >= 345 && Hpos < 370 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 345;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd83;
			end else	if (Hpos >= 380 && Hpos < 405 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 380;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd84;
			end else	if (Hpos >= 415 && Hpos < 440 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 415;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd00;
			end else	if (Hpos >=  450 && Hpos < 475 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 450;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd84;
			end else	if (Hpos >= 485 && Hpos < 510 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 485;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd79;
			end else	if (Hpos >= 495 && Hpos < 520 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 495;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd00;
			end else	if (Hpos >=  530 && Hpos < 555 && Vpos >= 300 && Vpos <= 345) begin
				xOffsetSml <= Hpos - 530;
				yOffsetSml <= Vpos - 300;
				asciiSml <= 12'd51;
				
			// DOWN: INFTY
			end else if (Hpos >= 100 && Hpos < 125 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 100;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd68;
			end else if (Hpos >= 135 && Hpos < 160 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 135;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd79;
			end else if (Hpos >=  170 && Hpos < 195 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 170;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd87;
			end else	if (Hpos >=  205 && Hpos < 230  && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 205;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd78;
			end else	if (Hpos >=  240 && Hpos < 265 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 240;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd58;	
			end else	if (Hpos >=  275 && Hpos < 300 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 275;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd00;
			end else	if (Hpos >= 310 && Hpos < 335 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 310;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd73;
			end else	if (Hpos >= 345 && Hpos < 370 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 345;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd78;
			end else	if (Hpos >= 380 && Hpos < 405 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 380;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd70;
			end else	if (Hpos >= 415 && Hpos < 440 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 415;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd84;
			end else	if (Hpos >=  450 && Hpos < 475 && Vpos >= 400 && Vpos <= 445) begin
				xOffsetSml <= Hpos - 450;
				yOffsetSml <= Vpos - 400;
				asciiSml <= 12'd89;
			end else begin
				asciiSml <= 0;
			end
			
		
			object <= isColorLarge | isColorSml;
		end else if (gameOver) begin	
			// GAMEOVER SCREEN
			if (Hpos >= 100 && Hpos < 125 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 100;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd80;
			end else if (Hpos >= 135 && Hpos < 160 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 135;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd76;
			end else if (Hpos >=  170 && Hpos < 195 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 170;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd65;
			end else	if (Hpos >=  205 && Hpos < 230  && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 205;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd89;
			end else	if (Hpos >=  240 && Hpos < 265 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 240;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd69;	
			end else	if (Hpos >=  275 && Hpos < 300 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 275;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd82;
			end else	if (Hpos >= 310 && Hpos < 335 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 310;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd00;
			end else	if (Hpos >= 345 && Hpos < 370 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 345;
				yOffsetSml <= Vpos - 200;
				
				// PRINTING 1 OR 2
				if (scoreOne > scoreTwo) begin
					asciiSml <= 12'd49;
				end else begin
					asciiSml <= 12'd50;
				end
			end else	if (Hpos >= 380 && Hpos < 405 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 380;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd00;
			end else	if (Hpos >= 415 && Hpos < 440 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 415;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd87;
			end else	if (Hpos >=  450 && Hpos < 475 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 450;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd79;
			end else	if (Hpos >= 485 && Hpos < 510 && Vpos >= 200 && Vpos <= 245) begin
				xOffsetSml <= Hpos - 485;
				yOffsetSml <= Vpos - 200;
				asciiSml <= 12'd78;
			end else begin
				asciiSml <= 0;
			end
			
			object <= isColorSml;
		end else begin
			// PAUSED WORDS
			if (paused) begin
				if (Hpos >= 30 && Hpos < 110 && Vpos >= 50 && Vpos <= 194) begin
					xOffsetNum <= Hpos - 30;
					yOffsetNum <= Vpos - 50;
					asciiNum <= 12'd80;
				end else if (Hpos >= 130 && Hpos < 210 && Vpos >= 50 && Vpos <= 194) begin
					xOffsetNum <= Hpos - 130;
					yOffsetNum <= Vpos - 50;
					asciiNum <= 12'd65;
				end else if (Hpos >= 230 && Hpos < 310 && Vpos >= 50 && Vpos <= 194) begin
					xOffsetNum <= Hpos - 230;
					yOffsetNum <= Vpos - 50;
					asciiNum <= 12'd85;
				end else	if (Hpos >= 330 && Hpos < 410 && Vpos >= 50 && Vpos <= 194) begin
					xOffsetNum <= Hpos - 330;
					yOffsetNum <= Vpos - 50;
					asciiNum <= 12'd83;
				end else	if (Hpos >= 430 && Hpos < 510 && Vpos >= 50 && Vpos <= 194) begin
					xOffsetNum <= Hpos - 430;
					yOffsetNum <= Vpos - 50;
					asciiNum <= 12'd69;
				end else	if (Hpos >= 530 && Hpos < 610 && Vpos >= 50 && Vpos <= 194) begin
					xOffsetNum <= Hpos - 530;
					yOffsetNum <= Vpos - 50;
					asciiNum <= 12'd68;
				end else begin
					asciiNum <= 0;
				end
			end else begin
		
				// PLAYER ONE SCORE
				scoreOneDigitOne = scoreOne % 10;
				scoreOneDigitTwo = ((scoreOne - scoreOneDigitOne) % 100) / 10;
				
				// PLAYER TWO SCORE
				scoreTwoDigitOne = scoreTwo % 10;
				scoreTwoDigitTwo = ((scoreTwo - scoreTwoDigitOne) % 100) / 10;
				
				
				// DIGIT ONE (10S FOR P1)
				if ((Hpos >= 93 && Hpos < 173 & Vpos >= 50 && Vpos <= 194)) begin
					if (scoreOneDigitTwo > 0) begin
						xOffsetNum <= Hpos - 93;
						yOffsetNum <= Vpos - 50;
						asciiNum <= (12'd48 + scoreOneDigitTwo);
					end else begin
						asciiNum <= 0;
					end
				// DIGIT TWO (1S FOR P1)
				end else if ((Hpos >= 193 && Hpos < 273 & Vpos >= 50 && Vpos <= 194)) begin
					xOffsetNum <= Hpos - 193;
					yOffsetNum <= Vpos - 50;
					asciiNum <= (12'd48 + scoreOneDigitOne);
				// DIGIT ONE (10S FOR P2)
				end else if ((Hpos >= 357 && Hpos < 437 & Vpos >= 50 && Vpos <= 194)) begin
					if (scoreTwoDigitTwo > 0) begin
						xOffsetNum <= Hpos - 357;
						yOffsetNum <= Vpos - 50;
						asciiNum <= (12'd48 + scoreTwoDigitTwo);
					end else begin
						asciiNum <= 12'd0;
					end
				// DIGIT TWO (1S FOR P2)
				end else if ((Hpos >= 457 && Hpos < 537 & Vpos >= 50 && Vpos <= 194)) begin
					xOffsetNum <= Hpos - 457;
					yOffsetNum <= Vpos - 50;
					asciiNum <= (12'd48 + scoreTwoDigitOne);
				end else begin
					asciiNum <= 12'd0;
				end
			end
			
			if (isColorNum == 1) begin
				object <= 1;
			end
			
			// BALL
			if ((Hpos >= (ballX - BALL_SIZE)) && (Hpos <= (ballX + BALL_SIZE)) && (Vpos >= (ballY - BALL_SIZE)) && (Vpos <= (ballY + BALL_SIZE))) begin
				object <= 1;
			end
			
			// P1 BLOCKER
			if ((Hpos >= (BLOCKER_PADDING - BLOCKER_WIDTH)) && (Hpos <= BLOCKER_PADDING) 
					&& (Vpos >= (blockerOneY - BLOCKER_SIZE)) && (Vpos <= blockerOneY + BLOCKER_SIZE)) begin
				object <= 1;
			end
			
			// P2 BLOCKER
			if ((Hpos >= (H_ACTIVE - BLOCKER_PADDING)) && (Hpos <= (H_ACTIVE - BLOCKER_PADDING + BLOCKER_WIDTH)) 
					&& (Vpos >= (blockerTwoY - BLOCKER_SIZE)) && (Vpos <= blockerTwoY + BLOCKER_SIZE)) begin
				object <= 1;
			end
			
			// CENTRE LINE
			if ((Hpos >= ((H_ACTIVE/2) - CENTRE_WIDTH)) && (Hpos <= ((H_ACTIVE/2) + CENTRE_WIDTH)) && centreCol) begin
				object <= 1;
			end
		end
		
		// ADDING COLOR
		if (videoActive) begin
			if (object) begin
				vgaR <= objectCol[23:16];
				vgaG <= objectCol[15:8];
				vgaB <= objectCol[7:0];
			end else begin
				vgaR <= backgroundCol[23:16];
				vgaG <= backgroundCol[15:8];
				vgaB <= backgroundCol[7:0];
			end
		end else begin
			vgaR <= 0;
			vgaG <= 0;
			vgaB <= 0;
		end
	end	
endmodule